Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaLRRpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:45:31 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34079 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaLRRp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:45:29 -0500
Message-ID: <549312BB.40400@ti.com>
Date: Thu, 18 Dec 2014 12:45:31 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Christopher Li <sparse@chrisli.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to fix CHECK warning: testing a 'safe expression' ?
References: <54907884.2040502@ti.com> <5491ACE6.4070108@ti.com> <CAErSpo4hwMPOYBDZTu_fgKaUDYZ4h+jVpz5EigpErOgo6xO8mQ@mail.gmail.com> <54920529.4080007@ti.com> <54920597.6090305@ti.com> <CANeU7Q=85c8ehgCitG-Ujrr5O78V1yq9o=abJ8pwBBs0JOWAEg@mail.gmail.com>
In-Reply-To: <CANeU7Q=85c8ehgCitG-Ujrr5O78V1yq9o=abJ8pwBBs0JOWAEg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2014 09:39 PM, Christopher Li wrote:
> On Thu, Dec 18, 2014 at 6:37 AM, Murali Karicheri<m-karicheri2@ti.com>  wrote:
>>          if (!ks_pcie) {
>>                  dev_err(dev, "no memory for keystone pcie\n");
>>                  return -ENOMEM;
>>          }
>>          pp =&ks_pcie->pp;
>>
>>          /* initialize SerDes Phy if present */
>>          phy = devm_phy_get(dev, "pcie-phy");
>> ===>     if (!IS_ERR_OR_NULL(phy)) {
>>                  ret = phy_init(phy);
>>                  if (ret<  0)
>>                          return ret;
>>
>
> Hi,
>
> Do you have a smaller stand alone test case which I can reproduce with sparse?
>
> Thanks
>
> Chris
Thanks Chris for responding.

You could add this piece of code for testing

struct foo {
	int x;
	int y;
};

static struct foo *func1(struct device *dev)
{
	struct foo *fp;

	fp = devm_kzalloc(dev, sizeof(*fp), GFP_KERNEL);
	if (fp == NULL)
		return ERR_PTR(-ENOMEM);
	return fp;
}

And in one of your module in kernel add

	struct foo *fp;

	if (IS_ERR_OR_NULL(fp))
		return -ENOMEM;

and do

make C=2 CF="-D__CHECK_ENDIAN__" CHECK=sparse

You will see the CHECK warning against your module as

include/linux/err.h:40:16: warning: testing a 'safe expression'

Hope this helps.

-- 
Murali Karicheri
Linux Kernel, Texas Instruments
