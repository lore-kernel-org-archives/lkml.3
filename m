Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab3CYK43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:56:29 -0400
Received: from mx2.digadd.de ([195.47.195.236]:60858 "EHLO mx1.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751049Ab3CYK42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:56:28 -0400
Message-ID: <51502D27.8080606@digadd.de>
Date: Mon, 25 Mar 2013 11:55:35 +0100
From: Christian Schmidt <schmidt@digadd.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130312 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: dm-crypt@saout.de, linux-kernel@vger.kernel.org
Subject: Re: kworkers for dm-crypt locked to CPU core 0?
References: <51501C0A.5060406@digadd.de> <m2obe7ixck.fsf@firstfloor.org>
In-Reply-To: <m2obe7ixck.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On 25/03/13 11:32, Andi Kleen wrote:
> Christian Schmidt <schmidt@digadd.de> writes:
>>
>> Is there a way I can make the scheduler put those on multiple cores?
> 
> Submit the IO from multiple cores. Don't use dd.

The dd processes run on multiple cores. I do understand that you were
saying "multiple requests to the same device from multiple cores",
however I only see kworkers from core 0 active, even with corelocked dd
processes (via numactl). Since I just skimmed to the pcrypt.c I kind of
realized that was the answer - do I understand correctly that the core
for the kworker follows the core of the requestor?

Basically that means that I can not get the aggregate throughput for all
devices higher than that for a single device by changing the stacking,
e.g. dm-crypt on top of md-raid / below the md-raid, or below zfs/btrfs
vdevs, since all user space requests will always appear to the crypto
layer to originate from core 0, irrespective of the core the application
runs on, unless the file system runs multithreaded? I just tested this
with ZFS, and all kworkers run on core 0 during file I/O or when
resilvering a raidZ. I don't have a btrfs managing its own vdevs at hand
to compare though.

Thanks for your input,
Christian
