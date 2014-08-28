Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046AbaH1MPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 08:15:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaH1MPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 08:15:06 -0400
Message-ID: <53FF1D44.3080702@suse.de>
Date: Thu, 28 Aug 2014 14:15:00 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
CC: linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 10/10] scsi/trace: Use scsi_print_command trace point
 instead of printk
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115030.6768.91195.stgit@yuno-kbuild.novalocal> <53FDE859.1020800@suse.de> <53FE8890.80403@hitachi.com> <53FEC9E7.6000909@hitachi.com>
In-Reply-To: <53FEC9E7.6000909@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2014 08:19 AM, Yoshihiro YUNOMAE wrote:
> Hi Hannes,
>
> I tried to remove duplicated decoder of SCSI command, but the
> output format of it in constants.c is different from it in traceevents.
> I have two questions for it.
>
> (Ex1)
> traceevents: TEST_UNIT_READY
> constants: Test Unit Ready
>
> => Which of "XXX_YYY_ZZZ" and "Xxx Yyy Zzz" should the kernel output
> strings? This difference comes from difference of implementation.
> The decoder in traceevents are using macro. So, it cannot define
> separated words. On the other hand, the decoder in constants are using
> constant string array table. So, it can define separated words.
>
I would go with the wording in constants.c, but set in double quotes 
like "Test Unit Ready" to avoid parsing errors later on.

> (Ex2)
> traceevents: (nothing)
> constants: Set limits(12)
>
> => Should we merge those decoder?
>
Yes, I would prefer this. Again, we should be setting the strings in 
double quotes irrespective if there are spaces in the resulting 
string or not.

> I understand we use the decoder of constants, but we need to solve
> these problems. Would you give me your comments?
>
As mentioned previously, my aim is to convert the logging system in 
several steps:

a) convert all lone 'printk' statements into dev_printk() variants
    and ensure everything is printed in one statement to avoid
    linebreaks in the resulting logging message.
    This will eliminate the immediate problem we're having, namely
    that debugging is near to impossible under high load.
    The patchset is nearing completion, and I will be posting it
    later this week.
b) Convert scsi_trace to use the functions from constants.c to
    avoid code duplication and update scsi_trace to log sense codes.
c) Remove all logging functions in the hot path (ie
    SCSI_LOG_MLQUEUE and SCSI_LOG_MLCOMPLETE) and replace them
    with trace events.

b) is what you're working on, right?
For 'c)' the problem is that we should retain the existing 
functionality with scsi_logging_level here, at least initially.
So we cannot just replace it, as this would leave SCSI_LOG_ML
a dummy without any real functionality.

I'll be posting my current patchset for review shortly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
