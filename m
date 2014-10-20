Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaJTWYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:24:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbaJTWYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:24:48 -0400
Date: Mon, 20 Oct 2014 15:24:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] kernel, add bug_on_warn
Message-Id: <20141020152448.c50fa1855d451f4bba0f6f92@linux-foundation.org>
In-Reply-To: <1413806420-31828-1-git-send-email-prarit@redhat.com>
References: <1413806420-31828-1-git-send-email-prarit@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014 08:00:20 -0400 Prarit Bhargava <prarit@redhat.com> wrote:

> There have been several times where I have had to rebuild a kernel to
> cause a panic when hitting a WARN() in the code in order to get a crash
> dump from a system.  Sometimes this is easy to do, other times (such as
> in the case of a remote admin) it is not trivial to send new images to the
> user.
> 
> A much easier method would be a switch to change the WARN() over to a
> BUG().  This makes debugging easier in that I can now test the actual
> image the WARN() was seen on and I do not have to engage in remote
> debugging.
> 
> This patch adds a bug_on_warn kernel parameter, which calls BUG() in the
> warn_slowpath_common() path.  The function will still print out the
> location of the warning.
> 
> Successfully tested by me.

Looks nice and simple and useful.  However I suspect you're exclusively
focussed on "I want a crash dump" and things haven't been fully thought
through.

- Do you have any example WARN->BUG console output at hand?  I'd like
  to check for missing or duplicated info.

- Did you consider permitting this to be tweaked at runtime via
  /proc?  Sometimes we get pesky WARNs at boot time and having runtime
  alteration would permit the user to prevent those from tripping a
  BUG.

- Also, perhaps bug_on_warn should be single-shot: clear itself after
  it has triggered one BUG.  Because once the kernel has gone
  WARN->BUG, it's probably messed up and is likely to trigger more
  WARNs.  Also, the kernel might generate many WARNs for the same
  issue.

> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -553,6 +553,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  	bttv.pll=	See Documentation/video4linux/bttv/Insmod-options
>  	bttv.tuner=
>  
> +	bug_on_warn	BUG() instead of WARN()

There's no mention here that this feature is mainly aimed at generating
a crash dump.  How do we tell the people who aren't reading this email
thread (ie: all of humanity except you and me ;)) that this feature
even exists?  Is there crash dump documentation that we can update?


