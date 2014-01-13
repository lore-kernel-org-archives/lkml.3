Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaAMN3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 08:29:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57670 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaAMN3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 08:29:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: build_skb() and data corruption
Date: Mon, 13 Jan 2014 14:29:37 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: netdev <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bhutchings@solarflare.com, alexander.h.duyck@intel.com,
        Florian Fainelli <florian@openwrt.org>
References: <CACmBeS35RAEQ+t2vtYtFTKNT-VdQw20hURjTi193Jk8HG7UECA@mail.gmail.com>
In-Reply-To: <CACmBeS35RAEQ+t2vtYtFTKNT-VdQw20hURjTi193Jk8HG7UECA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201401131429.38218.arnd@arndb.de>
X-Provags-ID: V02:K0:Or36iw3twG7zCVYjs3Fwmx6ep7PdO938jSDIHKBpQdN
 aiHSdSZtZlbMG+VJjRDnQ89mbaw6jjB4LsoEzNWckBUUlaaziY
 L3MnHdZOky34uB2iwEz2JjSTU8bpgOJQsBXNnKNYvIZtorys9v
 7MpC9lFoKdHt6MVoMuQ++AOOtpSgKlsiu2F5SPJvauKaCEPm58
 fEdWB+9pSNJsTxXnciVcQK26vEB3kuYb3j01Ps57MfSOrbix37
 agfl82nx2Wyc9sYJbgfSi7LjWTrc3OtigCv4I6fWLKwmNWWZ5F
 dzf478AWGQJJDJWJT7YRB8Azdr/6P44UVrEey9K3NoQCDWAiCf
 i07Vgk6XOlRn49eS/IpQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 January 2014, Jonas Jensen wrote:
> Please help,
> 
> I think I see memory corruption with a driver recently added to linux-next.
> 
> The following error occur downloading a large file with wget (or
> ncftp): "read error: Bad address"
> wget exits and leaves the file unfinished.
> 
> The error goes away when build_skb() is patched out, in this case by
> allocating pages directly in RX loop.
> 
> I currently have two branches with code placed under ifdef USE_BUILD_SKB:
> https://bitbucket.org/Kasreyn/linux-next/src/faa7c408a655fdfd7c383f79259031da5a05d61e/drivers/net/ethernet/moxa/moxart_ether.c#cl-472
> 

The problem appears to be incorrect coherency management of the
dma buffers. You are using the streaming DMA mapping API on a
platform that is not cache coherent, and you are reusing buffers.

The solution to this problem is to add the appropriate
dma_sync_single_for_device() and dma_sync_single_for_cpu()
calls at the point where buffer ownership changes between the
dma master and the CPU. This will flush the caches after the
filling them on the tx path and invalidate caches when the
dma master fills them on rx.

See Documentation/DMA-API-HOWTO.txt for details.

	Arnd
