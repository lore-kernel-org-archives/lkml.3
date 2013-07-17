Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab3GQPzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:55:39 -0400
Received: from 16.mo1.mail-out.ovh.net ([178.33.104.224]:43272 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755557Ab3GQPzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:55:38 -0400
Message-ID: <51E6BC23.6020700@overkiz.com>
Date: Wed, 17 Jul 2013 17:45:39 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH v3 6/7] USB: ohci-at91: add usb_clk for transition to
 common clk framework
References: <Pine.LNX.4.44L0.1307171131580.1555-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1307171131580.1555-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 13549642430621382758
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/2013 17:33, Alan Stern wrote:
> On Tue, 16 Jul 2013, Boris BREZILLON wrote:
>
>> The AT91 PMC (Power Management Controller) provides an USB clock used by
>> USB Full Speed host (ohci) and USB Full Speed device (udc).
>> The usb drivers (ohci and udc) must configure this clock to 48Mhz.
>> This configuration was formely done in mach-at91/clock.c, but this
>> implementation will be removed when moving to common clk framework.
>>
>> This patch add support for usb clock retrieval and configuration, and is
>> backward compatible with the current at91 clk implementation (if usb clk
>> is not found, it does not configure/enable the usb clk).
> This does not take into account any of the changes you discussed with
> Russell King and me -- it is exactly the same as the previous version.
Sorry, I don't understand. I didn't send any new version since yesterday.

I'm sending it right now and it's part of the
"ARM: at91: move to common clk framework" series (as discussed with you).


>> @@ -144,6 +150,11 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>>   		goto err2;
>>   	}
>>   
>> +	uclk = clk_get(&pdev->dev, "usb_clk");
>> +	if (IS_ERR(uclk)) {
>> +		uclk = NULL;
>> +		dev_warn(&pdev->dev, "failed to get usb_clk\n");
>> +	}
>>   	iclk = clk_get(&pdev->dev, "ohci_clk");
>>   	if (IS_ERR(iclk)) {
>>   		dev_err(&pdev->dev, "failed to get ohci_clk\n");
>> @@ -212,10 +223,11 @@ static void usb_hcd_at91_remove(struct usb_hcd *hcd,
>>   	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
>>   	usb_put_hcd(hcd);
>>   
>> +	clk_put(uclk);
> What will clk_put() do when uclk is NULL?
>
> Alan Stern
>

