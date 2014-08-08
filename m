Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbaHHFJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:09:01 -0400
Received: from linuxhacker.ru ([217.76.32.60]:58772 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796AbaHHFGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:06:36 -0400
Subject: Re: [PATCH] staging/lustre: use rcu_dereference to access rcu protected current->real_parent field
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140808044246.GA3084@kroah.com>
Date: Fri, 8 Aug 2014 01:06:15 -0400
Cc: Evgeny Budilovsky <budevg@gmail.com>, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>, linux-kernel@vger.kernel.org,
        Lai Siyao <lai.siyao@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <1FE03450-A256-4A18-85AB-6332A28E3EF5@linuxhacker.ru>
References: <87k36ltoob.fsf@gmail.com> <20140806214216.GA16530@kroah.com> <CAGDhxoe4+jU=vCDedMC4VXfuNMmqP3-E1Lu3LLStbFLbd=BRSA@mail.gmail.com> <20140808034951.GA6626@kroah.com> <DFF36154-06AC-4D7E-87F5-259B73CB059B@linuxhacker.ru> <20140808044246.GA3084@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 8, 2014, at 12:42 AM, Greg Kroah-Hartman wrote:

> On Fri, Aug 08, 2014 at 12:03:20AM -0400, Oleg Drokin wrote:
>> Hello!
>> 
>> On Aug 7, 2014, at 11:49 PM, Greg Kroah-Hartman wrote:
>>>> 
>>>> This is not a critical bug and in the worst case the code here may
>>>> cause miss of statistics counter increase.
>>>> This is why I think it is not worth to backport the patch at all.
>>> You are right, and if this is just for some random "statistics" file,
>>> can we just delete the whole function?
>> 
>> I hope not!
>> This is used all around the client to tally up various operations executed counts.
> Why would you do that?  Why would they care?

We would do that to provide information on the client operations performed.
They would care because they are interested in what particular clients might be doing.

>> The statistic is then used by various userspace monitoring tools.
> Why not use the in-kernel monitoring tools instead of creating your own?
> What does userspace do with that information?

We don't really control the userspace tools. People write tools to suit their needs
to monitor loads, see odd things the end users are doing or possibly for some
debugging even.
Correlating these numbers with what server sees also proves useful at times
(write combining for example).

Here's a sample of output of a recently mounted client that I poked on a bit (the lines starting with # are my comments):
# cat /proc/fs/lustre/llite/lustre-ffff88008dde27f0/stats
snapshot_time             1407473168.466102 secs.usecs
read_bytes                1 samples [bytes] 0 0 0
write_bytes               4 samples [bytes] 2 7 19
osc_write                 4 samples [bytes] 2 7 19
# The bytes counts show you minimum, maximum of writes seen and total number of bytes read-written.
# Lustre (and many other network filesystems) is very sensitive to small IO, esp. reads so it's good
# to know if you have a lot of it.
open                      6 samples [regs]
# The "regs" type just shows you how many of given type operations were performed since last statistic reset.
# Frequently that allows people to guess where does high load come from on a particular client when
# it's otherwise not obvious because not a lot of cpu is used.
# Some operations are heavier than others too.
close                     6 samples [regs]
readdir                   4 samples [regs]
setattr                   1 samples [regs]
truncate                  4 samples [regs]
getattr                   7 samples [regs]
create                    1 samples [regs]
alloc_inode               1 samples [regs]
getxattr                  8 samples [regs]
inode_permission          28 samples [regs]

As more operations types are seen the list grows.
Then there are also specific stats for readahead (data and metadata) so that interested people can make informed
decisions on the tuning there should they be unsatisfied with default settings.

I am not sure there's a similar mechanism in the kernel already that would allow us to get this sort of data easily
all in one place?

Bye,
    Oleg

