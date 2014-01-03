Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaACNhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:37:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbaACNhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:37:15 -0500
Date: Fri, 3 Jan 2014 14:24:32 +0100
From: mmarek <mmarek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Yang Bai <hamo.by@gmail.com>
Subject: Re: [PATCH] scripts: Have make TAGS not include structure members
Message-ID: <20140103132432.GA32469@sepie.suse.cz>
References: <20131115093645.6dc03918@gandalf.local.home>
 <CAMuHMdXSBSOkfd2MGbn=rpXQRZYw5TKLsR=3SoeSyrcD2CzunA@mail.gmail.com>
 <20131119155907.11fbdecea0aa40764a3d927a@linux-foundation.org>
 <20131119190426.27b010e4@gandalf.local.home>
 <20131119160855.2527630f87d060801d9ee3bb@linux-foundation.org>
 <20131119191435.4dce1499@gandalf.local.home>
 <528BFFBF.4050807@codeaurora.org>
 <20131119193414.48912cbd@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119193414.48912cbd@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 07:34:14PM -0500, Steven Rostedt wrote:
> I wasn't going to use this change, but instead add this change:
[...]
> --- linux-trace.git.orig/scripts/tags.sh	2013-11-19 19:29:34.352371615 -0500
> +++ linux-trace.git/scripts/tags.sh	2013-11-19 19:32:37.821152204 -0500
> @@ -218,7 +218,7 @@ exuberant()
>  
>  emacs()
>  {
> -	all_target_sources | xargs $1 -a                        \
> +	all_target_sources | xargs $@ -a                        \
>  	--regex='/^\(ENTRY\|_GLOBAL\)(\([^)]*\)).*/\2/'         \
>  	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
>  	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
> @@ -263,7 +263,7 @@ xtags()
>  	if $1 --version 2>&1 | grep -iq exuberant; then
>  		exuberant $1
>  	elif $1 --version 2>&1 | grep -iq emacs; then
> -		emacs $1
> +		emacs $@
>  	else
>  		all_target_sources | xargs $1 -a
>          fi
> @@ -313,7 +313,7 @@ case "$1" in
>  
>  	"TAGS")
>  		rm -f TAGS
> -		xtags etags
> +		xtags etags --no-members
>  		remove_structs=y


The logic looks OK, but it is not completely obvious that $@ means
'etags --no-members, iff called as etags'. How about using a more
descriptive variable like this?

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 58c4559..3afc479 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -219,7 +219,7 @@ exuberant()
 
 emacs()
 {
-	all_target_sources | xargs $1 -a                        \
+	all_target_sources | xargs $1 $no_members -a            \
 	--regex='/^\(ENTRY\|_GLOBAL\)(\([^)]*\)).*/\2/'         \
 	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
 	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
@@ -308,12 +308,15 @@ case "$1" in
 
 	"tags")
 		rm -f tags
+		no_members=
 		xtags ctags
 		remove_structs=y
 		;;
 
 	"TAGS")
 		rm -f TAGS
+		# Do not index struct members when generating Emacs TAGS
+		no_members=--no-members
 		xtags etags
 		remove_structs=y
 		;;

Michal
