Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbaGNSKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:10:12 -0400
Received: from p02c12o141.mxlogic.net ([208.65.145.74]:33637 "EHLO
	p02c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaGNSKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:10:08 -0400
X-MXL-Hash: 53c41d003e8e0015-57f5950f3527ae5025c9ca1fab7351aee8dedbe3
Date: Mon, 14 Jul 2014 14:10:00 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
CC: Joe Julian <joe@julianfamily.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Joe Maloy <joe.maloy@avagotech.com>
Subject: Re: mpt2sas stuck installing
Message-ID: <20140714141000.232d5e14@jlaw-desktop.mno.stratus.com>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B9907B@G9W0745.americas.hpqcorp.net>
References: <20140704013250.088477de@jlaw-desktop.mno.stratus.com>
	<53B649A6.60501@julianfamily.org>
	<alpine.DEB.2.02.1407072149190.10980@jlaw-desktop.mno.stratus.com>
	<53BDBB3A.5060906@julianfamily.org>
	<20140711225306.3ce78324@jlaw-desktop.mno.stratus.com>
	<94D0CD8314A33A4D9D801C0FE68B402958B9907B@G9W0745.americas.hpqcorp.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-AnalysisOut: [v=2.1 cv=atE8CEpV c=1 sm=1 tr=0 a=o2bo05G+d1rlxuoNbFVhCw==]
X-AnalysisOut: [:117 a=o2bo05G+d1rlxuoNbFVhCw==:17 a=_KQqW7t0BisA:10 a=BLc]
X-AnalysisOut: [eEmwcHowA:10 a=kj9zAlcOel0A:10 a=uelBKuKpAAAA:8 a=YlVTAMxI]
X-AnalysisOut: [AAAA:8 a=cH6R9-kdAAAA:8 a=VwQbUJbxAAAA:8 a=2SOu3le0Gyo7I5V]
X-AnalysisOut: [UPHkA:9 a=CjuIK1q_8ugA:10 a=bt0zGP92IBIA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014071411); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2014 03:13:07 +0000
"Elliott, Robert (Server Storage)" <Elliott@hp.com> wrote:

> 
> 
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > owner@vger.kernel.org] On Behalf Of Joe Lawrence
> ...
> > In your crash stack trace, the scsi error handler has issued a host
> > reset, but then crashed in mpt2sas_base_get_iocstate.  Reading through
> > _scsih_shutdown, I don't believe that the mpt2sas .shutdown path takes
> > any precaution before heading down mpt2sas_base_detach to free adapter
> > resources.  The ordinary .remove path looks similar, though it does
> > call sas_remove_host before freeing resources, *then* scsi_remove_host
> > and scsi_host_put.
> > 
> > I wonder if this ordering needs to be reversed (and added to
> > _scsih_shutdown) to properly de-register from the SCSI midlayer prior
> > to removing the controller instance.
> > 
> > Regards,
> > 
> > -- Joe
> 
> Nagalakshmi was working on an mpt3sas patch for the scsi-mq tree 
> to do just that.  I don't recall if the patch has made it into the 
> scsi-mq tree yet. Apparently it's also needed for non-mq and mpt2sas.
> 
> It is making this change:
> >  	sas_remove_host(shost);
> > +	scsi_remove_host(shost);
> >  	mpt3sas_base_detach(ioc);
> >  	list_del(&ioc->list);
> > -	scsi_remove_host(shost);
> >  	scsi_host_put(shost);
> 
> We are making a similar change in hpsa.  Doing so led to a general 
> protection fault, which unveiled that we also needed to change 
> cancel_delayed_work() calls to cancel_delayed_work_sync() to 
> ensure there are no worker functions still active after the 
> scsi_host structure is unregistered.

It looks like Sreekanth posted those patches today -- the new ordering
seems correct, but is there any reason why _scsih_shutdown skips
{sas,scsi}_remove_host calls?

Regards,

-- Joe
