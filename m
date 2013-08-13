Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab3HMA4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 20:56:20 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:40423 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab3HMA4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 20:56:19 -0400
Message-ID: <1376355303.10300.376.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/2] Protect cpu map updates from ACPI processor
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com
Date: Mon, 12 Aug 2013 18:55:03 -0600
In-Reply-To: <2206062.QmFJav0XuL@vostro.rjw.lan>
References: <1376322354-13026-1-git-send-email-toshi.kani@hp.com>
	 <2206062.QmFJav0XuL@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 02:43 +0200, Rafael J. Wysocki wrote:
> On Monday, August 12, 2013 09:45:52 AM Toshi Kani wrote:
> > CPU system maps are protected with reader/writer locks.  The reader
> > lock, put_online_cpus(), assures that the maps are not updated while
> > holding the lock.  The writer lock, cpu_hotplug_begin(), is used to
> > udpate the cpu maps along with cpu_maps_update_begin().
> > 
> > However, the ACPI processor handler updates the cpu maps without
> > holding the the writer lock.  This patchset fixes this problem.
> > 
> > ---
> > The patchset is based on linux-next of the pm tree.
> 
> Basically looks OK to me, but I'd just merge the patches together,
> because the [2/2] is the very reason for the change made by [1/2].

I separated for reviewing purpose, but yes, they can be together.  Let
me know if you need me to re-send it together.

> Also it would be good to mention the actual scenario that may lead
> to problems with that.

For example, the get_online_cpus() below is supposed to assure that
cpu_possible_mask is not changed while the code is iterating with
for_each_possible_cpu().

        get_online_cpus();
        for_each_possible_cpu(cpu) {
		:
        }
        put_online_cpus();

However, this lock has no protection with CPU hotplug since the ACPI
processor handler does not use the writer lock when it updates
cpu_possible_mask.  The reader lock does not serialize within the
readers.

Thanks,
-Toshi



