Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbaAHJF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:05:56 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:36264 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbaAHJFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:05:51 -0500
Date: Wed, 8 Jan 2014 10:05:41 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Peter Wu <lekensteyn@gmail.com>
Cc: linux-i2c@vger.kernel.org, Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: i801: fix memleak on probe error
Message-ID: <20140108100541.2ef7ebb7@endymion.delvare>
In-Reply-To: <4657870.yOE66qJqIC@al>
References: <20130123174204.00463f98@endymion.delvare>
	<1387791578-1372-1-git-send-email-lekensteyn@gmail.com>
	<4657870.yOE66qJqIC@al>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Joining the discussion late as I was on vacation...

On Mon, 23 Dec 2013 11:43:21 +0100, Peter Wu wrote:
> Nevermind this patch, it does not really fix the memleak because
> i2c_set_adapdata() calls dev_set_drvdata() which allocates memory.
> (I must have ran kmemleak too early, right after boot it did not
> give any warnings, now it does).

I can confirm that your proposed patch doesn't fix anything. It makes
no difference if pci_set_drvdata(dev, priv) is called earlier or later.

> RFC: what about dropping i2c_set_adapdata() from the probe function
> and replacing i2c_get_adapdata(adapter) by
> pci_get_drvdata(adapter->pci_dev) on top of this patch? I am not
> sure what the purpose is for i2c_set_adapdata, hence this question.

The purpose of i2c_set_adapdata is to attach a data structure to a
specific i2c_adapter device. In the case of the i2c-i801 driver,
there's only one such (class) device per PCI device so we could indeed
reuse the PCI device data pointer as you suggest above. But in the
general case there can be several i2c_adapter devices and each needs
its own data.

Also for performance reasons we don't want to do that because
pci_get_drvdata(adapter->pci_dev) is slower than
i2c_get_adapdata(adapter) (due to the extra pointer deference.) As this
happens repeatedly at run-time (in function i801_access) we want it to
be as fast as possible.

Note that we could (ab)use i2c_adapter.algo_data to store the
i2c_adapter device-specific data. Some drivers are doing exactly that,
for example i2c-nforce2. I suspect this legacy field is now somewhat
redundant with i2c_set_adapdata() as I couldn't find any i2c bus
driver using both.

-- 
Jean Delvare
