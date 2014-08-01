Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaHAUpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:45:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbaHAUpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:45:32 -0400
Date: Fri, 1 Aug 2014 13:45:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christopher Li <sparse@chrisli.org>, Ingo Molnar <mingo@redhat.com>,
        Jeff Layton <jlayton@poochiereds.net>, Michal Marek <mmarek@suse.cz>,
        Neil Brown <neilb@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 1/5] Add __designated_init, wrapping
 __attribute__((designated_init))
Message-Id: <20140801134529.40b46e92a48d9bf0c0abc139@linux-foundation.org>
In-Reply-To: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh@joshtriplett.org>
References: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh@joshtriplett.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014 16:47:23 -0700 Josh Triplett <josh@joshtriplett.org> wrote:

> GCC 4.10 and newer, and Sparse, supports
> __attribute__((designated_init)), which marks a structure as requiring
> a designated initializer rather than a positional one.  This helps
> reduce churn and errors when used with _ops structures and similar
> structures designed for future extension.
> 
> Add a wrapper __designated_init, which turns into
> __attribute__((designated_init)) for Sparse or sufficiently new GCC.
> Enable the corresponding warning as an error.
> 
> The following semantic patch can help mark structures containing
> function pointers as requiring designated initializers:
> 
> @@
> identifier I, f;
> type T;
> @@
> 
> struct I {
> 	...
> 	T (*f)(...);
> 	...
> }
> + __designated_init

hm, dunno about this.

I think that the kernel should always use designated initializers
everywhere.  Perhaps there are a few special cases where positional
initializers provide a superior result but I'm not sure where those
might be.

In which case what we should do is to teach sparse to warn about
positional initializers then go fix them all up (lol).  After that
process is complete, this __designated_init tag would be just noise.

To support this perhaps a sparse tag would be needed which says
"positional initializers are OK here".  This way we're adding the
annotation to the exceptional cases, not to the common cases.


