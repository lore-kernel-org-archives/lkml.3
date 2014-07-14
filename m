Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbaGNVXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:23:47 -0400
Received: from mail.net13.info ([92.39.235.156]:17866 "EHLO mail.net13.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793AbaGNVXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:23:44 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jul 2014 17:23:44 EDT
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Subject: Re: [PATCH] libata: handle IDE AMNF errors in the EH path
References: <1405153373-11108-1-git-send-email-alex@alex-at.ru>
 <20140714161010.GE31610@htj.dyndns.org>
Date: Tue, 15 Jul 2014 01:16:36 +0400
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Tejun Heo" <tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Alexey Asemov (Alex/AT)" <alex@alex-at.ru>
Message-ID: <op.xi0apyklxbnnkn@violator>
In-Reply-To: <20140714161010.GE31610@htj.dyndns.org>
User-Agent: Opera Mail/1.0 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote at Mon, 14 Jul 2014 20:10:10 +0400:

> IIRC AMNF has been deprecated for a very long time now.  The bit isn't
> too likely to get reused given that major updates to ATA spec is
> improbable but I'm still not quite fond of adding handling of a long
> deprecated flag.  Can you please provide a bit more detail?  Which
> device was it?

The hardware is: AMD 6550M-based notebook, WD7500BPVT 2.5" 750G SATA2 hard  
drive. PCI IDs for the controller are 1022:7801 subsys 1025:059d.

I was using linux-based machine to salvage data from failing hard drive,  
and found that pure AMNF 0x01 error code generates generic "device error"  
that is retried several times by SCSI stack instead of "media error" that  
is passed up to software. That slowed down salvaging a lot, so the  
patching was done and then everything went smooth.

So I presume AMNF error code is surely not dead yet, and it's better for  
it to be handled. It is used by modern enough devices, and used properly:  
drive returned AMNF only when IDs for track cannot be read completely due  
to dying head or positioning, otherwise it returned UNC(orrectables).  
Also, there is handling code in libata-scsi.c for 0x01 AMNF error already.  
Not handling it causes excessive retries that can damage failing drivers  
further, and wrong generic error code ("device error") reporting.
