Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaFYFep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:34:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57915 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaFYFen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:34:43 -0400
Date: Tue, 24 Jun 2014 22:34:42 -0700 (PDT)
Message-Id: <20140624.223442.1599243407487139839.davem@davemloft.net>
To: isubramanian@apm.com
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        rapatel@apm.com, kchudgar@apm.com
Subject: Re: [PATCH v8 4/4] drivers: net: Add APM X-Gene SoC ethernet
 driver support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403306296-26198-5-git-send-email-isubramanian@apm.com>
References: <1403306296-26198-1-git-send-email-isubramanian@apm.com>
	<1403306296-26198-5-git-send-email-isubramanian@apm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Jun 2014 22:34:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Iyappan Subramanian <isubramanian@apm.com>
Date: Fri, 20 Jun 2014 16:18:16 -0700

> This patch adds network driver for APM X-Gene SoC ethernet.
> 
> Signed-off-by: Iyappan Subramanian <isubramanian@apm.com>
> Signed-off-by: Ravi Patel <rapatel@apm.com>
> Signed-off-by: Keyur Chudgar <kchudgar@apm.com>

I really don't like how you handle the hardware descriptors in this
driver.

You copy back and forth between a software format and the hardware
format.  That's extremely wasteful and will hurt performance.

Just use the raw format throughout, you can extract the fields when
you need them.

You also make two passes when building a hardware descriptor:

1) write the values
2) endian swap

This means you make three memory accesses on every 64-bit word
in every descriptor you setup, this is really inefficient.

You should just byte swap them in-situ as you build the raw
descriptors.
