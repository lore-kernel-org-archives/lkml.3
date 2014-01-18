Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaARBfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 20:35:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55240 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaARBfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 20:35:14 -0500
Message-ID: <52D9DA4D.80407@canonical.com>
Date: Fri, 17 Jan 2014 20:35:09 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [v3.11][v3.12][v3.13][Regression] EISA: Initialize device before
 its resources
References: <52D81C92.9050800@canonical.com> <CAErSpo64e52Vv8bJ54cPcpnZ=OHMaxt2-D6dA4HCrrLnKo1n7g@mail.gmail.com> <52D82169.2000107@canonical.com> <20140117170204.GA13939@google.com> <52D983DF.3070202@canonical.com> <20140117221906.GA6219@google.com>
In-Reply-To: <20140117221906.GA6219@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 05:19 PM, Bjorn Helgaas wrote:
> On Fri, Jan 17, 2014 at 02:26:23PM -0500, Joseph Salisbury wrote:
>> On 01/17/2014 12:02 PM, Bjorn Helgaas wrote:
>>> On Thu, Jan 16, 2014 at 01:14:01PM -0500, Joseph Salisbury wrote:
>>>> On 01/16/2014 01:12 PM, Bjorn Helgaas wrote:
>>>>> On Thu, Jan 16, 2014 at 10:53 AM, Joseph Salisbury
>>>>> <joseph.salisbury@canonical.com> wrote:
>>>>>> Hi Bjorn,
>>>>>>
>>>>>> A kernel bug was opened against Ubuntu [0].  After a kernel bisect, it
>>>>>> was found the following commit introduced this bug:
>>>>> Sorry about that, and thanks for the report.  Did you mean to include
>>>>> URL for the bug?
>>>> Yes, sorry about that:
>>>> http://pad.lv/1251816
>>> Hi Joseph,
>>>
>>> Can you attach the 3.8.0-32-generic config (the one matching the successful
>>> boot at https://launchpadlibrarian.net/156685076/BootDmesg.txt) to the bug?
>> I attached the config file to the bug:
>> https://launchpadlibrarian.net/162754666/config.common.ubuntu
>>
>> I also attached a tar file with the complete config directory for that
>> kernel version.
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1251816/+attachment/3951156/+files/raring-config.tar
> Thanks again.  I attached the following reverts to launchpad.  I screwed up
> when doing those EISA changes.  I'd like to squeeze these into my v3.14
> merge request (probably early next week), so please test and let me know
> if this fixes the problem.  I'm really sorry for the inconvenience.
>
> Bjorn
>
>
> Revert "EISA: Log device resources in dmesg"
>
> From: Bjorn Helgaas <bhelgaas@google.com>
>
> This reverts commit a2080d0c561c546d73cb8b296d4b7ca414e6860b.
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/eisa/eisa-bus.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/eisa/eisa-bus.c b/drivers/eisa/eisa-bus.c
> index 8842cde69177..1b86fe0c2e80 100644
> --- a/drivers/eisa/eisa-bus.c
> +++ b/drivers/eisa/eisa-bus.c
> @@ -288,7 +288,6 @@ static int __init eisa_request_resources(struct eisa_root_device *root,
>  			edev->res[i].flags = IORESOURCE_IO | IORESOURCE_BUSY;
>  		}
>  
> -		dev_printk(KERN_DEBUG, &edev->dev, "%pR\n", &edev->res[i]);
>  		if (request_resource(root->res, &edev->res[i]))
>  			goto failed;
>  	}
> Revert "EISA: Initialize device before its resources"
>
> From: Bjorn Helgaas <bhelgaas@google.com>
>
> This reverts commit 26abfeed4341872364386c6a52b9acef8c81a81a.
>
> In the eisa_probe() force_probe path, if we were unable to request slot
> resources (e.g., [io 0x800-0x8ff]), we skipped the slot with "Cannot
> allocate resource for EISA slot %d" before reading the EISA signature in
> eisa_init_device().
>
> Commit 26abfeed4341 moved eisa_init_device() earlier, so we tried to read
> the EISA signature before requesting the slot resources, and this caused
> hangs during boot.
>
> Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1251816
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/eisa/eisa-bus.c |   26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/eisa/eisa-bus.c b/drivers/eisa/eisa-bus.c
> index 1b86fe0c2e80..612afeaec3cb 100644
> --- a/drivers/eisa/eisa-bus.c
> +++ b/drivers/eisa/eisa-bus.c
> @@ -277,11 +277,13 @@ static int __init eisa_request_resources(struct eisa_root_device *root,
>  		}
>  		
>  		if (slot) {
> +			edev->res[i].name  = NULL;
>  			edev->res[i].start = SLOT_ADDRESS(root, slot)
>  					     + (i * 0x400);
>  			edev->res[i].end   = edev->res[i].start + 0xff;
>  			edev->res[i].flags = IORESOURCE_IO;
>  		} else {
> +			edev->res[i].name  = NULL;
>  			edev->res[i].start = SLOT_ADDRESS(root, slot)
>  					     + EISA_VENDOR_ID_OFFSET;
>  			edev->res[i].end   = edev->res[i].start + 3;
> @@ -327,19 +329,20 @@ static int __init eisa_probe(struct eisa_root_device *root)
>  		return -ENOMEM;
>  	}
>  		
> -	if (eisa_init_device(root, edev, 0)) {
> +	if (eisa_request_resources(root, edev, 0)) {
> +		dev_warn(root->dev,
> +		         "EISA: Cannot allocate resource for mainboard\n");
>  		kfree(edev);
>  		if (!root->force_probe)
> -			return -ENODEV;
> +			return -EBUSY;
>  		goto force_probe;
>  	}
>  
> -	if (eisa_request_resources(root, edev, 0)) {
> -		dev_warn(root->dev,
> -		         "EISA: Cannot allocate resource for mainboard\n");
> +	if (eisa_init_device(root, edev, 0)) {
> +		eisa_release_resources(edev);
>  		kfree(edev);
>  		if (!root->force_probe)
> -			return -EBUSY;
> +			return -ENODEV;
>  		goto force_probe;
>  	}
>  
> @@ -362,11 +365,6 @@ static int __init eisa_probe(struct eisa_root_device *root)
>  			continue;
>  		}
>  
> -		if (eisa_init_device(root, edev, i)) {
> -			kfree(edev);
> -			continue;
> -		}
> -
>  		if (eisa_request_resources(root, edev, i)) {
>  			dev_warn(root->dev,
>  			         "Cannot allocate resource for EISA slot %d\n",
> @@ -375,6 +373,12 @@ static int __init eisa_probe(struct eisa_root_device *root)
>  			continue;
>  		}
>  
> +		if (eisa_init_device(root, edev, i)) {
> +			eisa_release_resources(edev);
> +			kfree(edev);
> +			continue;
> +		}
> +
>  		if (edev->state == (EISA_CONFIG_ENABLED | EISA_CONFIG_FORCED))
>  			enabled_str = " (forced enabled)";
>  		else if (edev->state == EISA_CONFIG_FORCED)
Thanks again for looking at this, Bjorn!

Yes, reverting commit 26abfeed4 does in fact resolve the bug.  I already
built a test kernel, noted in comment #34:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1251816/comments/34

The original bug reporter tested the kernel to confirm it fixes the bug:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1251816/comments/36

Would it be also possible for you to request the revert in the stable
trees, in addition to 3.14?

Thanks,

Joe


