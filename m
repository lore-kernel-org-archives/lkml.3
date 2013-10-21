Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3JUM1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 08:27:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab3JUM1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 08:27:00 -0400
Message-ID: <52651D8C.3090203@redhat.com>
Date: Mon, 21 Oct 2013 08:26:52 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org,
        herrmann.der.user@googlemail.com, tigran@aivazian.fsnet.co.uk
Subject: Re: [PATCH 2/2] intel_microcode, Fix long microcode load time when
 firmware file is missing
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>	<1382304926-1641-3-git-send-email-prarit@redhat.com> <CACVXFVMjEnkk8zYycsk6t4WiWOJ_NT1AKFoK7p5mQnFkw9KE-g@mail.gmail.com>
In-Reply-To: <CACVXFVMjEnkk8zYycsk6t4WiWOJ_NT1AKFoK7p5mQnFkw9KE-g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/21/2013 08:20 AM, Ming Lei wrote:
> On Mon, Oct 21, 2013 at 5:35 AM, Prarit Bhargava <prarit@redhat.com> wrote:
>> If no firmware is found on the system that matches the processor, the
>> microcode module can take hours to load.  For example on recent kernels
>> when loading the microcode module on an Intel system:
>>
>> [  239.532116] microcode: CPU0 sig=0x306e4, pf=0x1, revision=0x413
>> [  299.693447] microcode: CPU1 sig=0x306e4, pf=0x1, revision=0x413
>> [  359.821972] microcode: CPU2 sig=0x306e4, pf=0x1, revision=0x413
>> [  419.960263] microcode: CPU3 sig=0x306e4, pf=0x1, revision=0x413
>> [  480.090024] microcode: CPU4 sig=0x306e4, pf=0x1, revision=0x413
>> ...
>> [ 2825.151364] microcode: CPU43 sig=0x306e4, pf=0x1, revision=0x413
>> [ 2885.280863] microcode: CPU44 sig=0x306e4, pf=0x1, revision=0x413
>> [ 2945.410719] microcode: CPU45 sig=0x306e4, pf=0x1, revision=0x413
>> [ 3005.540541] microcode: CPU46 sig=0x306e4, pf=0x1, revision=0x413
>> [ 3065.670405] microcode: CPU47 sig=0x306e4, pf=0x1, revision=0x413
>> ...
>> etc.
>>
>> Similarly there is a 60 second "hang" when loading the AMD module, which
>> isn't as bad as the Intel situation, but it is a noticeable delay in the
>> system boot and can be improved upon.
>>
>> Using request_firmware_nowait() seems more appropriate here and then we
>> can avoid these delays, resulting in very quick load times for the
>> microcode.
> 
> request_firmware_nowait() should be a good idea for the problem, but
> why do you pass FW_ACTION_NOHOTPLUG as uevent?  It is used now
> by drivers which requires their own user-space applications to handle
> the request by polling the firmware device under sysfs.

Hello Ming,

Oh, I see.

> 
> So I am wondering if your microcode case belongs to the above case
> of FW_ACTION_NOHOTPLUG?

You're right.  I can easily change that in v2.

> 
> And why don't you pass FW_ACTION_HOTPLUG? and you are sure
> that udev isn't required to handle your microcode update request?
> 

AFAICT in both cases, udev wasn't required to handle the cpu microcode update.
Both drivers use CMH to load the firmware which removes the need for udev to do
anything.  Admittedly maybe I've missed some odd use case but I don't think it
is necessary.

P.
