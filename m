Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab3FIB7o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 21:59:44 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:54662 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3FIB7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 21:59:43 -0400
Date: Sat, 08 Jun 2013 13:56:01 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: Strange intermittent EIO error when writing to stdout since
 v3.8.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
References: <20130606115417.GA520@x4>
In-Reply-To: <20130606115417.GA520@x4> (from markus@trippelsdorf.de on Thu
	Jun  6 06:54:17 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1370717761.2776.84@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 06:54:17 AM, Markus Trippelsdorf wrote:
> Since v3.8.0 several people reported intermittent IO errors that  
> happen
> during high system load while using "emerge" under Gentoo:
...
> see: https://bugs.gentoo.org/show_bug.cgi?id=459674
> 
> (A similar issue also happens when building Firefox since v3.8.0. But
> because Firefox's build process doesn't raise an exception it just  
> dies
> at random points without giving a clue.)
> 
> Now the question is: Could this be a kernel bug? Maybe in the TTY  
> layer?
> 
> Unfortunately the issue is not easily reproducible and a git-bisect is
> out of the question.

I tracked down and fixed something like this in the User Mode Linux tty  
implementation many moons ago.

The trick to making it reproducible was to rename a copy of the xterm  
binary to somethingunique, run a shell in said xterm (because "cat"  
doesn't exercise the tty logic, that's why), run a thing in there  
producing test output, and have a loop in another window doing "while  
true; do killall -STOP somethingunique; sleep 1; killall -START  
somethingunique; sleep 1; done".

This forces the pipe buffer to the pty to fill up and exercise the flow  
control logic, plus all the fun "short write and retry" stuff...

Rob