Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337Ab3JOQ3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:29:47 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2289 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881Ab3JOQ3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:29:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 15 Oct 2013 09:25:21 -0700
From: Vishal Annapurve <vannapurve@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>, Ming Lei <tom.leiming@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Date: Tue, 15 Oct 2013 21:59:39 +0530
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result
Thread-Topic: [PATCH] usb-storage: scsiglue: Changing the command result
Thread-Index: Ac7Jvus8aKrvvBBwTqGG5HrPc+oCRgABCPlw
Message-ID: <113ACA888B71994BB56E5CF3704953486D65F41133@BGMAIL02.nvidia.com>
References: <CACVXFVPd9UQqMZFFsogMESzpDP=JVCpDJGWTAMrNHNazocJD4w@mail.gmail.com>
 <Pine.LNX.4.44L0.1310151151340.1377-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1310151151340.1377-100000@iolanthe.rowland.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

This issue seems more related to the devices using SCSI protocol and the
changes otherwise will be at more places giving the same end result.

I think as the comment says over the command_abort function,
intentional result change should only happen in case of timeout.

Regards,
Vishal

-----Original Message-----
From: Alan Stern [mailto:stern@rowland.harvard.edu] 
Sent: Tuesday, October 15, 2013 5:55 PM
To: Ming Lei
Cc: Vishal Annapurve; Linux Kernel Mailing List; linux-usb
Subject: Re: [PATCH] usb-storage: scsiglue: Changing the command result

On Tue, 15 Oct 2013, Ming Lei wrote:

> On Thu, Sep 26, 2013 at 7:35 PM, Vishal Annapurve <vannapurve@nvidia.com> wrote:
> > Hi,
> >
> > There was a recent commit in mainline for the scsi devices which do 
> > not respond properly to medium access command:
> >
> > commit    18a4d0a22ed6c54b67af7718c305cd010f09ddf8
> >
> > [SCSI] Handle disk devices which can not process medium access 
> > commands We have experienced several devices which fail in a fashion 
> > we do not currently handle gracefully in SCSI. After a failure these 
> > devices will respond to the SCSI primary command set (INQUIRY, TEST 
> > UNIT READY, etc.) but any command accessing the storage medium will time out.
> >
> > I came across a USB drive which showed similar problem and what I 
> > see is usb storage is still not able to cope with such devices properly.
> >
> > The control flow downwards is like:
> > scsi_times_out --> Setting cmd->result as DID_TIME_OUT 
> > scsi_error_handler scsi_unjam_host scsi_eh_abort_cmds
> > command_abort    (sets US_FLIDX_TIMED_OUT for us->dflags
> >                                   calls stop_transport,
> >                                   and waits for)    usb_stor_control_thread
> > (which is waiting for
> >                                                                    
> > transport call to return inside
> >
> > usb_stor_invoke_transport)
> >                                                                    
> > both usb_stor_control_thread and
> >
> > usb_stor_invoke_transport
> >                                                     check for 
> > us->dflags timed_out bit and
> >                                                      set the result 
> > as DID_ABORT
> >                                                      and signal 
> > completion for command_abort
> >                                                      to complete 
> > ......
> > sd_eh_action
> > checks for cmd->result and finds out that it's DID_ABORT rather than 
> > DID_TIME_OUT.
> >
> > This patch updates the command result to be TIME_OUT explicitly 
> > before returning from command_abort in scsiglue.c.
> >
> > I would like to know if this patch can work out for such USB Storage 
> > devices? What would be the better way to do the same?
> 
> Looks your diagnose is correct, and patch should be doable, the only 
> side effect is that previous returned DID_ABORT in srb->result is 
> replaced with DID_TIME_OUT now.
> 
> Another way is to implement .eh_timed_out callback to return different 
> error for the two failure, but looks not a big deal.

Instead of overriding the result code, a better way to do this would simply be to change the places where srb->result is currently set to DID_ABORT << 16.  Just make it DID_TIME_OUT << 16 instead.

Alan Stern

