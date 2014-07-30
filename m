Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaG3O4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:56:06 -0400
Received: from smtp.multi.fi ([85.134.37.151]:58760 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbaG3O4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:56:04 -0400
X-Greylist: delayed 1090 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jul 2014 10:56:04 EDT
Message-ID: <53D90312.2030802@mageia.org>
Date: Wed, 30 Jul 2014 17:37:06 +0300
From: Thomas Backlund <tmb@mageia.org>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Kevin Hao <haokexin@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3.12 81/94] libata: support the ata host which implements
 a queue depth less than 32
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz> <7e8fe9628fa3b778bf8b00c5faead306e80c0a47.1406722270.git.jslaby@suse.cz>
In-Reply-To: <7e8fe9628fa3b778bf8b00c5faead306e80c0a47.1406722270.git.jslaby@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby skrev den 30.7.2014 15:15:
> From: Kevin Hao <haokexin@gmail.com>
>
> 3.12-stable review patch.  If anyone has any objections, please let me know.
>
> ===============
>
> commit 1871ee134b73fb4cadab75752a7152ed2813c751 upstream.
>
> The sata on fsl mpc8315e is broken after the commit 8a4aeec8d2d6
> ("libata/ahci: accommodate tag ordered controllers"). The reason is
> that the ata controller on this SoC only implement a queue depth of
> 16. When issuing the commands in tag order, all the commands in tag
> 16 ~ 31 are mapped to tag 0 unconditionally and then causes the sata
> malfunction. It makes no senses to use a 32 queue in software while
> the hardware has less queue depth. So consider the queue depth
> implemented by the hardware when requesting a command tag.
>
> Fixes: 8a4aeec8d2d6 ("libata/ahci: accommodate tag ordered controllers")
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

As you have added this to 3.12 branch, you also need to add this to 
avoid SAS breakage:

commit 1a112d10f03e83fb3a2fdc4c9165865dec8a3ca6
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Jul 23 09:05:27 2014 -0400

     libata: introduce ata_host->n_tags to avoid oops on SAS controllers

     1871ee134b73 ("libata: support the ata host which implements a queue
     depth less than 32") directly used ata_port->scsi_host->can_queue from
     ata_qc_new() to determine the number of tags supported by the host;
     unfortunately, SAS controllers doing SATA don't initialize ->scsi_host
     leading to the following oops.

--

Thomas

