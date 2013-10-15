Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab3JOPzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:55:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58620 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759343Ab3JOPy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:54:56 -0400
Date: Tue, 15 Oct 2013 11:54:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <tom.leiming@gmail.com>
cc: Vishal Annapurve <vannapurve@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-storage: scsiglue: Changing the command result
In-Reply-To: <CACVXFVPd9UQqMZFFsogMESzpDP=JVCpDJGWTAMrNHNazocJD4w@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1310151151340.1377-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013, Ming Lei wrote:

> On Thu, Sep 26, 2013 at 7:35 PM, Vishal Annapurve <vannapurve@nvidia.com> wrote:
> > Hi,
> >
> > There was a recent commit in mainline for the scsi devices which do not
> > respond properly to medium access command:
> >
> > commit    18a4d0a22ed6c54b67af7718c305cd010f09ddf8
> >
> > [SCSI] Handle disk devices which can not process medium access commands
> > We have experienced several devices which fail in a fashion we do not
> > currently handle gracefully in SCSI. After a failure these devices will
> > respond to the SCSI primary command set (INQUIRY, TEST UNIT READY, etc.)
> > but any command accessing the storage medium will time out.
> >
> > I came across a USB drive which showed similar problem and what I see is
> > usb storage is still not able to cope with such devices properly.
> >
> > The control flow downwards is like:
> > scsi_times_out --> Setting cmd->result as DID_TIME_OUT
> > scsi_error_handler
> > scsi_unjam_host
> > scsi_eh_abort_cmds
> > command_abort    (sets US_FLIDX_TIMED_OUT for us->dflags
> >                                   calls stop_transport,
> >                                   and waits for)    usb_stor_control_thread
> > (which is waiting for
> >                                                                    transport
> > call to return inside
> >
> > usb_stor_invoke_transport)
> >                                                                    both
> > usb_stor_control_thread and
> >
> > usb_stor_invoke_transport
> >                                                     check for us->dflags
> > timed_out bit and
> >                                                      set the result as
> > DID_ABORT
> >                                                      and signal completion
> > for command_abort
> >                                                      to complete
> > ......
> > sd_eh_action
> > checks for cmd->result and finds out that it's DID_ABORT rather than
> > DID_TIME_OUT.
> >
> > This patch updates the command result to be TIME_OUT explicitly before
> > returning from command_abort in scsiglue.c.
> >
> > I would like to know if this patch can work out for such USB Storage
> > devices? What would be the better way to do the same?
> 
> Looks your diagnose is correct, and patch should be doable, the
> only side effect is that previous returned DID_ABORT in srb->result
> is replaced with DID_TIME_OUT now.
> 
> Another way is to implement .eh_timed_out callback to return different
> error for the two failure, but looks not a big deal.

Instead of overriding the result code, a better way to do this would
simply be to change the places where srb->result is currently set to
DID_ABORT << 16.  Just make it DID_TIME_OUT << 16 instead.

Alan Stern

