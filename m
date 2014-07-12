Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaGLDQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 23:16:44 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:28571 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaGLDQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 23:16:42 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Joe Lawrence <joe.lawrence@stratus.com>, Joe Julian <joe@julianfamily.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Joe Maloy <joe.maloy@avagotech.com>
Subject: RE: mpt2sas stuck installing
Thread-Topic: mpt2sas stuck installing
Thread-Index: AQHPl0llMSzGFpFWbUqZ0QGQ356UuZuVcFKwgALjLwCAA3a7AIAAAmqg
Date: Sat, 12 Jul 2014 03:13:07 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B9907B@G9W0745.americas.hpqcorp.net>
References: <20140704013250.088477de@jlaw-desktop.mno.stratus.com>
 <53B649A6.60501@julianfamily.org>
 <alpine.DEB.2.02.1407072149190.10980@jlaw-desktop.mno.stratus.com>
 <53BDBB3A.5060906@julianfamily.org>
 <20140711225306.3ce78324@jlaw-desktop.mno.stratus.com>
In-Reply-To: <20140711225306.3ce78324@jlaw-desktop.mno.stratus.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Joe Lawrence
...
> In your crash stack trace, the scsi error handler has issued a host
> reset, but then crashed in mpt2sas_base_get_iocstate.  Reading through
> _scsih_shutdown, I don't believe that the mpt2sas .shutdown path takes
> any precaution before heading down mpt2sas_base_detach to free adapter
> resources.  The ordinary .remove path looks similar, though it does
> call sas_remove_host before freeing resources, *then* scsi_remove_host
> and scsi_host_put.
> 
> I wonder if this ordering needs to be reversed (and added to
> _scsih_shutdown) to properly de-register from the SCSI midlayer prior
> to removing the controller instance.
> 
> Regards,
> 
> -- Joe

Nagalakshmi was working on an mpt3sas patch for the scsi-mq tree 
to do just that.  I don't recall if the patch has made it into the 
scsi-mq tree yet. Apparently it's also needed for non-mq and mpt2sas.

It is making this change:
>  	sas_remove_host(shost);
> +	scsi_remove_host(shost);
>  	mpt3sas_base_detach(ioc);
>  	list_del(&ioc->list);
> -	scsi_remove_host(shost);
>  	scsi_host_put(shost);

We are making a similar change in hpsa.  Doing so led to a general 
protection fault, which unveiled that we also needed to change 
cancel_delayed_work() calls to cancel_delayed_work_sync() to 
ensure there are no worker functions still active after the 
scsi_host structure is unregistered.


