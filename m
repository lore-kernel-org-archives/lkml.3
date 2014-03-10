Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaCJQNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:13:51 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:2842 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752277AbaCJQNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:13:50 -0400
Date: Mon, 10 Mar 2014 12:13:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ktest: remove the misleading $buildonly and
 introduce $laststep.
Message-ID: <20140310121300.485d2202@gandalf.local.home>
In-Reply-To: <87eh2b30ce.wl%satoru.takeuchi@gmail.com>
References: <87ha7730nw.wl%satoru.takeuchi@gmail.com>
	<87fvmr30kb.wl%satoru.takeuchi@gmail.com>
	<87eh2b30ce.wl%satoru.takeuchi@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Mar 2014 23:36:49 +0900
Satoru Takeuchi <satoru.takeuchi@gmail.com> wrote:

> From: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> 
> Each test of ktest consists of the following steps.
> 
>   build -> install -> boot -> run user defined tests.
> 
> $buildonly means not whether the test is build onlyor not. Actually
> this variable mean the last step of the test as follows.
> 
>  0: boot or more
>  1: build
>  2: install
> 
> AS you can see, these are random numeric literals. In addition,
> there is no explanation about them.
> 
> To improve readability, introduce $laststep instead of $buildonly.
> This variable means the last step of the test as follows.
> 
>  STEP_BUILD (=0):        build
>  STEP_INSTALL (=1):      install
>  STEP_BOOT_OR_MORE (=2): boot or more

Nice clean up. But there's some bugs in this patch.

 
> @@ -649,26 +651,20 @@ sub set_value {
>  
>      my $prvalue = process_variables($rvalue);
>  
> -    if ($buildonly && $lvalue =~ /^TEST_TYPE(\[.*\])?$/ && $prvalue ne "build") {
> -	# Note if a test is something other than build, then we
> -	# will need other manditory options.
> -	if ($prvalue ne "install") {
> -	    # for bisect, we need to check BISECT_TYPE
> -	    if ($prvalue ne "bisect") {
> -		$buildonly = 0;

When prvalue ne "bisect" we set it to boot or more.

> +    if ($laststep <= STEP_INSTALL)  {
> +	if ($lvalue =~ /^TEST_TYPE(\[.*\])?$/ && $prvalue ne "build") {
> +	    # Note if a test is something other than build, then we
> +	    # will need other manditory options.
> +	    if ($prvalue eq "install") {
> +		# install still limits some manditory options.
> +		$laststep = STEP_INSTALL;
> +	    } elsif ($prvalue ne "bisect") {
> +		# for bisect, we need to check BISECT_TYPE
> +		$laststep = STEP_BUILD;

Here you set it back to build.

>  	    }
> -	} else {
> -	    # install still limits some manditory options.
> -	    $buildonly = 2;
> -	}
> -    }
> -
> -    if ($buildonly && $lvalue =~ /^BISECT_TYPE(\[.*\])?$/ && $prvalue ne "build") {
> -	if ($prvalue ne "install") {
> -	    $buildonly = 0;
> -	} else {
> -	    # install still limits some manditory options.
> -	    $buildonly = 2;
> +	} elsif ($lvalue =~ /^BISECT_TYPE(\[.*\])?$/ &&
> +		   $prvalue ne "build") {
> +	    $laststep = ($prvalue eq "install") ? STEP_INSTALL : STEP_BUILD;

Here too.

In fact, with this patch, we never set to boot or more.

Also, you can make it even cleaner, by having the outer if condition be:

	if ($laststep <= STEP_INSTALL && $prvalue ne "build")

And remove the prvalue check from the inner conditions.

Just send a fix of this patch, I have already pulled in the other two.
I just need to test them for a bit before I push them to my kernel.org
repo. I don't actually have a test suite for ktest. My testing is that
I use ktest on a daily basis, and I just use the latest devel ktest for
my daily activities. If something breaks, I usually notice, unless it's
affects something I haven't done recently (like a bisect).

Thanks,

-- Steve

>  	}
>      }
>  
> @@ -4045,7 +4041,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
>      $dmesg = "$tmpdir/dmesg-$machine";
>      $output_config = "$outputdir/.config";
>  
> -    if (!$buildonly) {
> +    if ($laststep >= STEP_BOOT_OR_MORE) {
>  	$target = "$ssh_user\@$machine";
>  	if ($reboot_type eq "grub") {
>  	    dodie "GRUB_MENU not defined" if (!defined($grub_menu));

