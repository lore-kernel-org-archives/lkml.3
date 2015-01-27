Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbbA0Eqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:46:31 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42660 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbbA0Eq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:46:27 -0500
Date: Tue, 27 Jan 2015 04:46:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150127044625.GX29656@ZenIV.linux.org.uk>
References: <20150126150913.653681560@goodmis.org>
 <20150126193049.GN29656@ZenIV.linux.org.uk>
 <20150126214020.GO29656@ZenIV.linux.org.uk>
 <20150126183739.1d17fd82@gandalf.local.home>
 <20150126213419.531774eb@grimm.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126213419.531774eb@grimm.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 09:34:19PM -0500, Steven Rostedt wrote:
> On Mon, 26 Jan 2015 18:37:39 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> 
> > > the first call of tracing_init_dentry().  Prior to that it's NULL.
> > > BTW, may I politely inquire what the fuck are those contortions in
> > > tracing_init_dentry_tr() about?  Looks like a stunningly convoluted
> > > way to trigger that automount point creation early in
> > > tracer_init_tracefs(). Why not do that right there explicitly?
> > 
> > Yeah, that could be cleaned up. Before the tracefs code, it made much
> > more sense to keep that as a single function. Now that
> > global_array.dir is treated differently as the subdirs, it does make
> > sense to have global_arry.dir initialized in a separate function.
> > 
> > I'll update my patch series to do this.
> 
> Now I remember why I did this (as I changed the code and everything
> blew up). The files in the tracing directory can be created by several
> users (do a grep for fs_initcall() in kernel/trace/*.c). The first
> caller to add a file initializes the tracing directory.
> 
> I guess I can have all the other callers use fs_initcall_sync(). I'm
> assuming those come after fs_initcall().

Ah...  That explains some of the oddities of that kind (not all of them,
though - your trace_options_init_dentry() is called by
create_trace_option_dirs() and create_trace_option_core_file(), which is
called only by create_trace_option_dirs(), and that - quite a few times,
each time calling trace_options_init_dentry()).

Strange style, IMO.  Frankly, I'd rather have the ordering as explicit as it
gets...
