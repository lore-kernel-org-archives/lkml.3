Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3HaSks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 14:40:48 -0400
Received: from server19320154104.serverpool.info ([193.201.54.104]:57257 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415Ab3HaSkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 14:40:46 -0400
Message-ID: <522238A1.3080008@hauke-m.de>
Date: Sat, 31 Aug 2013 20:40:33 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list@broadcom.com,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: linux-next: Tree for Aug 30 (brcmfmac)
References: <20130829200013.d9dde1eb64686a32c661b5d3@canb.auug.org.au> <52210AB9.2090104@infradead.org> <CAMuHMdXFmWyiUJF+4HbD=6oGPVXHBAVx=rOC7u=motTQFCKn7g@mail.gmail.com> <5222341B.4070205@broadcom.com>
In-Reply-To: <5222341B.4070205@broadcom.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2013 08:21 PM, Arend van Spriel wrote:
> On 08/31/13 19:37, Geert Uytterhoeven wrote:
>> On Fri, Aug 30, 2013 at 11:12 PM, Randy Dunlap<rdunlap@infradead.org> 
>> wrote:
>>> This bool kconfig symbol:
>>>
>>> config BRCMFMAC_SDIO
>>>          bool "SDIO bus interface support for FullMAC driver"
>>>          depends on MMC
>>>
>>> allows BRCMFMAC_SDIO to be y even when MMC=m.
>>>
>>> Is there a reasonable solution to this?
> 
> Actually, BRCMFMAC should be built in same form as the MMC and/or USB,
> but only when BRCMFMAC_SDIO or BRCMFMAC_USB are selected.
> 
> So valid combinations are:
> MMC=m, USB=m, BRCMFMAC_SDIO=y, BRCMFMAC_USB=y => BRCMFMAC=m
> MMC=m, USB=y, BRCMFMAC_SDIO=y, BRCMFMAC_USB=y => BRCMFMAC=m
> MMC=y, USB=m, BRCMFMAC_SDIO=y, BRCMFMAC_USB=y => BRCMFMAC=m
> MMC=m, USB=y, BRCMFMAC_SDIO=y, BRCMFMAC_USB=n => BRCMFMAC=m
> MMC=m, USB=y, BRCMFMAC_SDIO=n, BRCMFMAC_USB=y => BRCMFMAC=m|y
> MMC=y, USB=m, BRCMFMAC_SDIO=y, BRCMFMAC_USB=n => BRCMFMAC=m|y
> MMC=y, USB=m, BRCMFMAC_SDIO=n, BRCMFMAC_USB=y => BRCMFMAC=m
> MMC=y, USB=y, BRCMFMAC_SDIO=y, BRCMFMAC_USB=y => BRCMFMAC=m|y
> MMC=y, USB=y, BRCMFMAC_SDIO=y, BRCMFMAC_USB=n => BRCMFMAC=m|y
> MMC=y, USB=y, BRCMFMAC_SDIO=n, BRCMFMAC_USB=y => BRCMFMAC=m|y
> 
> Not sure how to express the above.

This should be expressed with this Kconfig:

config BRCMFMAC_USB
	bool "USB bus interface support for FullMAC driver"
	depends on (USB = y || USB = BRCMFMAC)
	depends on BRCMFMAC

config BRCMFMAC_SDIO
	bool "SDIO bus interface support for FullMAC driver"
	depends on (MMC = y || MMC = BRCMFMAC)
	depends on BRCMFMAC
	select FW_LOADER

I haven't tested it, but we had a similar problem in b43 and fixed it
like this.

Hauke
