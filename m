Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab3DFDBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 23:01:17 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:54156 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab3DFDBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 23:01:15 -0400
Date: Sat, 6 Apr 2013 05:01:13 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC] revoke(2) and generic handling of things like remove_proc_entry()
Message-ID: <20130406030113.GB30194@order.stressinduktion.org>
Mail-Followup-To: Al Viro <viro@ZenIV.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexey Dobriyan <adobriyan@gmail.com>
References: <20130405042932.GB4068@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130405042932.GB4068@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 05:29:32AM +0100, Al Viro wrote:
> 4) nasty semantics issue - mmap() vs. revoke (of any sort, including
> remove_proc_entry(), etc.).  Suppose a revokable file had been mmapped;
> now it's going away.  What should we do to its VMAs?  Right now sysfs
> and procfs get away with that, but only because there's only one thing
> that has ->mmap() there - /proc/bus/pci and sysfs equivalents.  I've
> no idea how does pci_mmap_page_range() interact with PCI hotplug (and
> I'm not at all sure that whatever it does isn't racy wrt device removal),
> but I suspect that it strongly depends on lack of ->fault() for those
> VMAs, which makes killing all PTEs pointing to pages in question enough.
> How generic do we want to make it?  Anybody wanting to add more files
> that could be mmapped in procfs/sysfs/debugfs deserves to be hurt, but
> if we start playing with revoke(2), restriction might become inconvenient.
> I'm not sure what kind of behaviour do we want there - *BSD at least
> used to have revoke(2) only for character devices that had no mmap()...

I am seeing possible problems in software implementing their own memory
management ontop SIGSEGV e.g. java. I hope they sanely distinguish
between heap mappings and file mmaps.

FreeBSD allowes tearing down a mmap on MAC security relabel. Two possible
actions are available: SIGSEGV generation by tearing down the mapping
forcefully or enable some kind of copy-on-write semantics on revoke:

http://svnweb.freebsd.org/base/head/sys/security/mac/mac_process.c?revision=248084&view=markup

I like to see something like revoke being worked on, thanks!

Greetings,

  Hannes

