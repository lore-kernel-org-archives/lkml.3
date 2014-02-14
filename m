Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaBNVqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:46:34 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:64869 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaBNVqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:46:32 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: Chaoming_Li <chaoming_li@realsil.com.cn>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] rtlwifi: avoid accessing RCR directly
Date: Fri, 14 Feb 2014 22:46:28 +0100
Message-ID: <3888493.2VXzEtRsP2@al>
User-Agent: KMail/4.12.2 (Linux/3.13.2-custom; KDE/4.12.2; x86_64; ; )
In-Reply-To: <52FE8A8C.6040407@lwfinger.net>
References: <1392401026-18417-1-git-send-email-lekensteyn@gmail.com> <1392401026-18417-2-git-send-email-lekensteyn@gmail.com> <52FE8A8C.6040407@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 February 2014 15:28:44 Larry Finger wrote:
> On 02/14/2014 12:03 PM, Peter Wu wrote:
> > The rtl*_set_check_bssid functions are mostly the same, but access the
> > RCR register in different ways. Use the get_hw_reg abstraction layer
> > (which reads rtlpci->receive_config for PCI devices and mac->rx_conf for
> > USB).
> > 
> > There is no functional change for cases where receive_config was
> > accessed directly. For rtl8192ce, there is still no change because
> > nothing modifies REG_RCR or receive_config. For rtl8192cu, it now also
> > applies changes to rx_conf from configure_filter, but that can be
> > considered a bug which is fixed later.
> > 
> > Signed-off-by: Peter Wu <lekensteyn@gmail.com>
> 
> Acked-by: Larry Finger <Larry.Finger@lwfinger>

TLD is missing ;)

> With this change it will not take much work to move all the
> *_set_check_bssid  functions into a common version in rtlwifi. But that
> will have to wait as I have one new driver submitted, but not merged, and
> two others that are not quite ready for submission.

There are three variants of the set_check_bssid functions:
- four that modify the beacon filter (through _rtl*_set_bcn_ctrl_reg)
- one (rtl8192se) that does not modify the beacon filter and writes
  less bits (just RCR_BSSID instead of RCR_BSSID_{DATA,BCN})
- one (rtl8192cu) that modifies the beacon filter, and depending on
  the chip version, sets the same bits as rtl8192se, or the other four.

I was not sure where to move the set_bcn_ctrl_reg functions, these
depend on a value from rtl*/reg.h. Perhaps the [gs]et_hw_reg functions
can be extended with these registers?

Thanks,
Peter

