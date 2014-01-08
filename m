Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbaAHPls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:41:48 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:37010 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbaAHPlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:41:45 -0500
Date: Wed, 8 Jan 2014 16:40:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Wu <lekensteyn@gmail.com>
Subject: Freeing of dev->p
Message-ID: <20140108164058.059cf461@endymion.delvare>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, hi all,

A memory leak has been reported to me:
http://marc.info/?l=linux-i2c&m=138779165123331&w=2

The leak is in i801_probe, caused by an early call to
i2c_set_adapdata() which in turn calls dev_set_drvdata() which
allocates some memory in device_private_init(). That memory is only
freed by the driver core when the i2c_adapter class device is removed.
But if the parent (PCI) device probing itself fails for whatever
reason, the class device never gets to be created, so it's never
removed, thus the memory is never freed.

It is not possible to move the call to i2c_set_adapdata() until after
the class device is created, because the data pointed is needed very
early after (almost during) i2c adapter creation. So I could make the
leak less likely to happen but I can't fix it completely.

I am wondering how this can be solved, and this brought three questions:

1* What is the rationale for allocating dev->p dynamically? It is
allocated as soon as the device is created (in device_add), so as far
as I can see every device will need the allocation. Including struct
device_private in struct device would not cost more memory, plus it
would reduce memory fragmentation. So is this a lifetime issue? Or
something else I can't think of?

2* What is the rationale for making void *driver_data part of struct
device_private and not struct device itself?

3* If the current implementation is considered correct, does it mean
that dev_set_drvdata() should never be used for class devices?

Thanks,
-- 
Jean Delvare
