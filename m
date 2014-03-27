Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaC0HhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 03:37:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbaC0HhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 03:37:07 -0400
From: Markus Armbruster <armbru@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alejandro Comisario <alejandro.comisario@mercadolibre.com>,
        kvm@vger.kernel.org, ghammer@redhat.com,
        Stefan Hajnoczi <stefanha@gmail.com>, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] Massive read only kvm guests when backing file was missing
References: <CAMrG31z=oy-53Lfya4svhNniD_7Q1YETuHeZsotHj8U5xJNYmw@mail.gmail.com>
	<20140327064158.GA17563@redhat.com>
Date: Thu, 27 Mar 2014 08:36:57 +0100
In-Reply-To: <20140327064158.GA17563@redhat.com> (Michael S. Tsirkin's message
	of "Thu, 27 Mar 2014 08:41:58 +0200")
Message-ID: <87y4zwt7mu.fsf@blackfin.pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Wed, Mar 26, 2014 at 11:08:03PM -0300, Alejandro Comisario wrote:
>> Hi List!
>> Hope some one can help me, we had a big issue in our cloud the other
>> day, a couple of our openstack regions ( +2000 kvm guests with qcow2 )
>> went read only filesystem from the guest side because the backing
>> files directory (the openstack _base directory) was compromised and
>> the data was lost, when we realized the data was lost, it took us 5
>> mins to restore the backup of the backing files, but by that time all
>> the kvm guests received some kind of IO error from the hypervisor
>> layer, and went read only on root filesystem.
>> 
>> My question would be, is there a way to hold the IO operations against
>> the backing files ( i thought that would be 99% READ operations ) for
>> a little longer ( im asking this because i dont quite understand what
>> is the process and when it raises the error ) in a case the backing
>> files are missing (no IO possible) but is recoverable within minutes ?
>> 
>> Any tip  on how to achieve this if possible, or information about how
>> backing files works on kvm, will be amazing.
>> Waiting for feedback!
>> 
>> kindest regards.
>> Alejandro Comisario
>
>
> I'm guessing this is what happened: guests timed out meanwhile.
> You can increase the timeout within the guest:
> echo 600 > /sys/block/sda/device/timeout
> to timeout after 10 minutes.
>
> If you have installed qemu guest agent on your system, you can do this
> from the host. Unfortunately by default it's memory can be pushed out to swap
> and then on disk error access there might will fail :(
> Maybe we should consider mlock on all its memory at least as an option.
>
> You could pause your guests, restart them after the issue is resolved,
> and we could I guess add functionality to pause VM on disk errors
> automatically.
> Stefan?

Would -drive rerror=stop do?
