Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaFDDZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 23:25:40 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59869 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbaFDDZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 23:25:38 -0400
Date: Tue, 3 Jun 2014 20:25:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Francesco Ruggeri <fruggeri@aristanetworks.com>,
        linux-kernel@vger.kernel.org, hare@suse.de, fruggeri@arista.com
Subject: Re: pci: kernel crash in bus_find_device
Message-ID: <20140604032533.GA22469@roeck-us.net>
References: <20140603225502.F1C5122C07D5@bs320.sjc.aristanetworks.com>
 <20140603232100.GA15247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603232100.GA15247@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 04:21:00PM -0700, Greg KH wrote:
> On Tue, Jun 03, 2014 at 03:55:02PM -0700, Francesco Ruggeri wrote:
> > In-Reply-To: <20140523023141.GC13900@kroah.com>
> > 
> > 
> > Hi Guenter,
> > I got back to looking into this crash.
> > Just as an example, the attached diffs also fix my bus_find_device problem for
> > traversals that start from the head of the list and traverse it completely.
> > They are very specific to the case of bus_find_device, and a complete solution
> > would affect a lot of code.
> > The main issue seems to be that when a device is found in a klist by say
> > bus_find_device the klist_node reference should be returned to the caller,
> > who should then decide whether to use it for the next klist search, drop it or
> > maybe exchange it for a struct device reference. When resuming a search one
> > should already hold a klist_node reference from the previous search.
> > This model is broken by several functions using struct devices such as
> > bus_find_device, which resume klist searches on the implicit assumption that
> > holding a reference to the struct device is enough to acquire one on the
> > klist_node. 
> > The only reason that this has not been a big issue so far is probably that
> > on most systems struct devices are not destroyed and created very often.
> 
> Not true, this happens on every USB device insertion and removal, and on
> startup and shutdown.  What makes PCI special that we aren't hitting
> these issues in USB and other subsystems that do a lot of device
> creation/removal?
> 
Look for callers of bus_find_device. Unless I am missing something, only pci
and scsi code call it with non-NULL 'start' argument, and the scsi use is
limited to a walk through scsi devices for a proc file.

Makes me wonder if the start argument should go away, and if pci and scsi
should use another means to walk through devices.

Guenter
