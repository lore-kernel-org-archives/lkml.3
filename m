Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbbA0Ail (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:38:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:53276 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755755AbbA0Aij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:38:39 -0500
Date: Mon, 26 Jan 2015 19:39:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150126193909.19967bd0@grimm.local.home>
In-Reply-To: <20150126184916.70d88963@gandalf.local.home>
References: <20150126150913.653681560@goodmis.org>
	<20150126193049.GN29656@ZenIV.linux.org.uk>
	<20150126154259.5e650d32@gandalf.local.home>
	<20150126214658.GQ29656@ZenIV.linux.org.uk>
	<20150126184314.24f2583c@gandalf.local.home>
	<20150126184916.70d88963@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 18:49:16 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 26 Jan 2015 18:43:14 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>  
> > That is, we can not hold i_mutex and take trace_types_lock.
> > 
> > trace_types_lock needs to be held with the creation or destruction
> > of events, which is what mkdir an rmdir do.
> 
> Although, I can not remember how this happened, but lockdep blew up on
> me with this. I'll look again.

OK, found it. When events are created (module is loaded), the
trace_types_lock is taken, and the event directories are created (these
are in /sys/kernel/debug/tracing/events). We need to grab the i_mutex
in order to create these files.

This means that we can not take the trace_types_lock within the mkdir
or rmdir calls.

The directories are not static even outside the mkdir and rmdir calls.
As events can be created from several sources, which will create new
files and directories.

-- Steve
