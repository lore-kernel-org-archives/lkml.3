Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaDVKXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:23:14 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52809 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbaDVKXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:23:12 -0400
Date: Tue, 22 Apr 2014 11:22:59 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        pmladek@suse.cz, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/8] printk: Add config option for disabling printk
 offloading
Message-ID: <20140422112259.5f106a44@alan.etchedpixels.co.uk>
In-Reply-To: <20140418115438.1e65e07af17e3ba6d7c554db@linux-foundation.org>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
	<1395770101-24534-9-git-send-email-jack@suse.cz>
	<20140326172332.5f1e1bfb@alan.etchedpixels.co.uk>
	<20140326192815.GC18118@quack.suse.cz>
	<20140418115438.1e65e07af17e3ba6d7c554db@linux-foundation.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2014 11:54:38 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 26 Mar 2014 20:28:15 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > > All the afflicted consoles are serial, all go via the uart layer as far
> > > as I can see.
> > > 
> > > The uart layer has a queue mechanism that could be used
> >   I'm sorry, I don't follow here - what can the uart queueing be used for?
> 
> Alan, I'm desperate to avoid adding all this complexity to core printk
> code to solve such a rare problem.  It'd be great if you could flesh out
> any alternative ideas please.

It's not worth adding for upstream anyway - not in that form. If it just
used schedule_work it would be way way cleaner anyway.

For the general buffering case we already have tty_write_message(). It's
only really intended for use by the old quota code so it's currently
assuming nul terminated string but thats a trivial detail.

For that matter I don't see why such systems can't implement a queuecon
console which is a queue on the printk side and a fifo on the userspace
side.

The implementation then becomes trivial.

If you want reliable crash logging then we need to be able to set a
printk level mask per console and just set the serial console for
"crit/err" and the queue console for the rest, with a 'cat
>/dev/ttywhatever' running if this feature was in use ?

Alan
