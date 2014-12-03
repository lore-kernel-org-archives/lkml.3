Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaLCMtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:49:05 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:20722 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaLCMtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:49:04 -0500
X-IronPort-AV: E=Sophos;i="5.07,507,1413270000"; 
   d="scan'208";a="52324509"
Message-ID: <547F06BC.8060000@broadcom.com>
Date: Wed, 3 Dec 2014 13:49:00 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Jeremiah Mahler <jmmahler@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the net-next
 tree
References: <20141201181933.6dfaad66@canb.auug.org.au> <547C19ED.10201@broadcom.com> <20141203083655.GA5418@hudson.localdomain> <20141203105148.GA7633@hudson.localdomain>
In-Reply-To: <20141203105148.GA7633@hudson.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/14 11:51, Jeremiah Mahler wrote:
> On Wed, Dec 03, 2014 at 12:36:55AM -0800, Jeremiah Mahler wrote:
>> all,
>>
>> On Mon, Dec 01, 2014 at 08:34:05AM +0100, Arend van Spriel wrote:
>>> On 01-12-14 08:19, Stephen Rothwell wrote:
>>>> Hi Greg,
>>>>
>>>> Today's linux-next merge of the driver-core tree got a conflict in
>>>> drivers/net/wireless/ath/ath9k/debug.c between commits 70e535ed0029
>>>> ("ath9k: clean up debugfs print of reset causes"), 7b8aaead958e
>>>> ("ath9k: restart hardware after noise floor calibration failure") and
>>>> 325e18817668 ("ath9k: fix misc debugfs when not using chan context")
>>>> from the net-next tree and commit 631bee257bd5 ("ath: use seq_file api
>>>> for ath9k debugfs files") from the driver-core tree.
>>>>
>>>> I fixed it up (see below) and can carry the fix as necessary (no action
>>>> is required).
>>>>
>>>> Greg, I am not sure why those 2 commits are even in your tree.  Do they
>>>> depend on something else in your tree?
>>>
>>> They do. The three commits below are related:
>>>
>>> d32394f ath: ath9k: use debugfs_create_devm_seqfile() helper for
>>> seq_file entrie
>>> 631bee2 ath: use seq_file api for ath9k debugfs files
>>> 98210b7 debugfs: add helper function to create device related seq_file
>>>
>>> The ath patches were made to provide example of using the new helper
>>> function and get some idea about code savings. Greg and John discussed
>>> who would take them. I noticed other ath changes in net-next so I kinda
>>> expected this email ;-)
>>>
>>> Regards,
>>> Arend
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>> I just ran in to a problem with one of these commits.
>>
>> On an Acer C720 laptop if a suspend is performed the screen freezes,
>> the machine locks up, and according to the indicator lights it does
>> not enter suspend.  A hard reset is required to get it running again.
>>
>> I have bisected the kernel and found that the following is the first bad
>> commit.
>>
>>    commit d32394fae95741d733b174ec1446f27765f80233
>>    Author: Arend van Spriel<arend@broadcom.com>
>>    Date:   Sun Nov 9 11:32:00 2014 +0100
>>
>>        ath: ath9k: use debugfs_create_devm_seqfile() helper for seq_file
>>    entries
>>
>>        Use the helper to get rid of the file operations per debugfs file.
>>    The
>>        struct ath9k_softc pointer is set as device driver data to be
>>    obtained
>>        in the seq_file read operation.
>>
>>        Signed-off-by: Arend van Spriel<arend@broadcom.com>
>>        Signed-off-by: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
>>
>> Let me know if I can do anything else to help.
>>
>> --
>> - Jeremiah Mahler
>
> I took a look at the patch that is causing this problem (d32394fae95).
> My config negates everything in the patch except for a one line change
> to ath9k/pci.c.  If I remove this change (shown below) the problem goes
> away.

Ok. But then it will likely crash when you cat one of the changed 
debugfs files. Guess this commit needs to be reverted entirely.

Regards,
Arend

> diff --git a/drivers/net/wireless/ath/ath9k/pci.c
> b/drivers/net/wireless/ath/ath9k/pci.c
> index 90c9e3c..c018dea 100644
> --- a/drivers/net/wireless/ath/ath9k/pci.c
> +++ b/drivers/net/wireless/ath/ath9k/pci.c
> @@ -856,7 +856,6 @@ static int ath_pci_probe(struct pci_dev *pdev, const
> struct pci_device_id *id)
>          sc = hw->priv;
>          sc->hw = hw;
>          sc->dev =&pdev->dev;
> -       dev_set_drvdata(sc->dev, sc);
>          sc->mem = pcim_iomap_table(pdev)[0];
>          sc->driver_data = id->driver_data;
>

