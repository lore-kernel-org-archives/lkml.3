Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab3CMAoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 20:44:12 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:3957 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755325Ab3CMAoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 20:44:09 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail03.sonyusa.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(z21eIzbb2dI98dI936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h93fhd25hf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh162dh1631h1758h18e1h190ch1946h19c3h1b0ah1155h)
Message-ID: <513FCBD3.4@am.sony.com>
Date: Tue, 12 Mar 2013 17:44:03 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: Re: linux-3.6.11-rt30 smoke test on ARM
References: <51396143.5060108@am.sony.com> <51396306.6090902@am.sony.com> <20130311173424.GB22286@linutronix.de>
In-Reply-To: <20130311173424.GB22286@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/13 10:34, Sebastian Andrzej Siewior wrote:
> * Frank Rowand | 2013-03-07 20:03:18 [-0800]:
> 
>> panda boot often fails due to a usb timeout, while sending a command on
>> behalf of the smsc95xx ethernet driver.
>>
>> This patch is a temporary hack to force a retry when the timeout occurs.
> 
> It looks like you overrun the chip for some reason. Can you reproduce it
> on mainline? They added a few delayes on register read() it might do the
> trick.

Yes, I can reproduce it on mainline.

Here is the current state of my debugging:

The problem usually occurs within three boot attempts.  But it has also
taken eight boot attempts to see the problem.  I do not know what the
maximum number of boots is required to see the problem, so I can not
state with certainty that a given kernel version does not have the
problem.  If the boot fails then I can state with certainty that the
given kernel version has the problem.

Given that level of uncertainty, I know:

  v3.5      does not appear to have the problem
  v3.6-rc1  has the problem
  v3.6      has the problem
  v3.7      has the problem
  v3.8      does not appear to have the problem
  v3.9-rc1  fails to build

I thought I had bisected the problem to a specific commit, but wanting
to be sure of it, I did extra boots of what should have been the last
good commit.  On the 7th boot, that kernel version had the problem.

I'll probably redo the bisect, but have not had time to do so yet.

The problem manifests as a timeout from at least two different locations
in drivers/net/usb/smsc95xx.c:


 656 static int smsc95xx_set_mac_address(struct usbnet *dev)
 657 {
 ...
 663         ret = smsc95xx_write_reg(dev, ADDRL, addr_lo);
 664         if (ret < 0) {
 665                 netdev_warn(dev->net, "Failed to write ADDRL: %d\n", ret);
 666                 return ret;
 667         }


751 static int smsc95xx_reset(struct usbnet *dev)
 752 {
 ...
 783         write_buf = PM_CTL_PHY_RST_;
 784         ret = smsc95xx_write_reg(dev, PM_CTRL, write_buf);
 785         if (ret < 0) {
 786                 netdev_warn(dev->net, "Failed to write PM_CTRL: %d\n", ret);
 787                 return ret;
 788         }


Some of the other smsc95xx_write_reg() calls in smsc95xx_reset() are protected with
checks for timeout, with up to 100 retries.  I do not know if this one should have
the same protection.

-Frank

