Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab3GII2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:28:32 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:41515 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab3GII2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:28:23 -0400
Message-ID: <51DBC99F.4030301@openvz.org>
Date: Tue, 09 Jul 2013 12:28:15 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
References: <20130708100046.14417.12932.stgit@zurg> <20130708170047.GA18600@mtj.dyndns.org> <20130708175201.GB9094@redhat.com> <20130708175607.GB18600@mtj.dyndns.org>
In-Reply-To: <20130708175607.GB18600@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Vivek.
>
> On Mon, Jul 08, 2013 at 01:52:01PM -0400, Vivek Goyal wrote:
>>> Again, a problem to be fixed in the stack rather than patching up from
>>> up above.  The right thing to do is to propagate pressure through bdi
>>> properly and let whatever is backing the bdi generate appropriate
>>> amount of pressure, be that disk or network.
>>
>> Ok, so use network controller for controlling IO rate on NFS? I had
>> tried it once and it did not work. I think it had problems related
>> to losing the context info as IO propagated through the stack. So
>> we will have to fix that too.
>
> But that's a similar problem we have with blkcg anyway - losing the
> dirtier information by the time writeback comes down through bdi.  It
> might not be exactly the same and might need some impedance matching
> on the network side but I don't see any fundamental differences.
>
> Thanks.
>

Yep, blkio has plenty problems and flaws and I don't get how it's related
to vfs layer, dirty set control and non-disk or network backed filesystems.
Any problem can be fixed by introducing new abstract layer, except too many
abstraction levels. Cgroup is pluggable subsystem, blkio has it's own plugins
and it's build on top of io scheduler plugin. All this stuff always have worked
with block devices. Now you suggest to handle all filesystems in this stack.
I think binding them to unrealated cgroup is rough leveling violation.

NFS cannot be controlled only by network throttlers because we cannot slow down
writeback process when it happens, we must slow down tasks who generates dirty memory.
Plus it's close to impossible to separate several workloads if they share one NFS sb.
