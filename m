Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaANPwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:52:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63260 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaANPwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:52:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: build_skb() and data corruption
Date: Tue, 14 Jan 2014 16:51:34 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: netdev <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        alexander.h.duyck@intel.com, Florian Fainelli <florian@openwrt.org>,
        Ben Hutchings <bhutchings@solarflare.com>
References: <CACmBeS35RAEQ+t2vtYtFTKNT-VdQw20hURjTi193Jk8HG7UECA@mail.gmail.com> <1389620539.3720.157.camel@deadeye.wl.decadent.org.uk> <CACmBeS1gTfdjwiCkHMViOnF6G2zjy3HSMm3NVq8Jiq5F22ynJA@mail.gmail.com>
In-Reply-To: <CACmBeS1gTfdjwiCkHMViOnF6G2zjy3HSMm3NVq8Jiq5F22ynJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201401141651.34633.arnd@arndb.de>
X-Provags-ID: V02:K0:cHPRVIx5O/ODy9uDc9Xb9kHRpXF4GW9Oy+NlzqXCCUf
 PUVY1Vt3+gKFSz8YjvzVhk4ubpp5PiEQHOGhrMNFc/MMgwVNhu
 b+7iAm6PuZj0KLAEi6IyyG+YvzUiWPDgZg7KJ/TTDHq2RyIVhs
 CToYyRuZcsy+HXm4RhQuAv9HBuULUVZk5qrMYMl2UM3GHfzjcH
 faPujo26CMh6Klaqt98ADAPnZA5tQw1GrA9RNqHlrJJImPz1EB
 Jic0U39d4A0DVzBgh6xwHLpFCWiUwicntc3M4w5VVw/m8n8Yav
 dxku+z3tvqAedgS5ZqdFBlSfhxxtfr9ldtXumbv5OCK9ARQIBT
 2vvZZFDYvEMS97of1Dzg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 January 2014, Jonas Jensen wrote:
> Thanks for the replies, you led me to a new solution,
> 
> 
> I now think build_skb() is not the right choice, my motivation for
> using it in the first place, that I thought it meant getting away with
> not copying memory.
> 
> build_skb() is replaced by netdev_alloc_skb_ip_align() and memcpy()
> (derived from drivers/net/ethernet/realtek/r8169.c).
> 
> Read errors are gone, even without syncing DMA. Is it a good idea to
> do it anyway, i.e. leave calls to dma_sync_single_* in?

The calls to dma_sync_single_* in the moxart_rx() function are needed.
The call to arm_dma_ops.sync_single_for_device() in
moxart_mac_setup_desc_ring() is wrong, because the buffer is already
owned by the device at that point (just after dma_map_single), and
because you should use the official dma_* api rather than using
the arm_dma_ops struct.

	Arnd
