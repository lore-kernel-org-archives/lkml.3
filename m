Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab3BFU6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:58:33 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14241 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3BFU6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:58:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 06 Feb 2013 12:56:08 -0800
Message-ID: <5112C3EB.7020205@nvidia.com>
Date: Wed, 6 Feb 2013 12:58:19 -0800
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 4/8] gpu: host1x: Add debug support
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com> <1358250244-9678-5-git-send-email-tbergstrom@nvidia.com> <20130204110339.GA28134@avionic-0098.mockup.avionic-design.de> <51108D75.9030302@nvidia.com> <20130205091555.GC20437@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130205091555.GC20437@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.02.2013 01:15, Thierry Reding wrote:
> On Mon, Feb 04, 2013 at 08:41:25PM -0800, Terje Bergström wrote:
>> This is used by debugfs code to direct to debugfs, and
>> nvhost_debug_dump() to send via printk.
> 
> Yes, that was precisely my point. Why bother providing the same data via
> several output methods. debugfs is good for showing large amounts of
> data such as register dumps or a tabular representation of syncpoints
> for instance.
> 
> If, however, you want to interactively show debug information using
> printk the same format isn't very useful and something more reduced is
> often better.

debugfs is there to be able to get a reliable dump of host1x state
(f.ex. no lines intermixed with other output).

printk output is there because often we get just UART logs from failure
cases, and having as much information as possible in the logs speeds up
debugging.

Both of them need to output the values of sync points, and the channel
state. Dumping all of that consists of a lot of code, and I wouldn't
want to duplicate that for two output formats.

>> I have another suggestion. In downstream I removed the decoding part and
>> I just print out a string of hex. That removes quite a bit bunch of code
>> from kernel. It makes the debug output also more compact.
> I don't know. I think if you use in-kernel debugging facilities such as
> debugfs or printk, then the output should be self-explanatory. However I
> do see the usefulness of having a binary dump that can be decoded in
> userspace. But I think if we want to go that way we should make that a
> separate interface. USB provides something like that, which can then be
> fed to libpcap or wireshark to capture and analyze USB traffic. If done
> properly you get replay functionality for free. I don't know what infra-
> structure exists to help with implementing something similar.

It's not actually binary. I think I misrepresented the suggestion.

I'm suggesting that we'd display only the contents of command FIFO and
contents of gathers (i.e. all opcodes) in hex format, not decoded. All
other text would remain as is, so syncpt values, etc would be readable
by a glance.

The user space tool can then take the streams and decode them if needed.

We've noticed that the decoded opcodes format can be very long and
sometimes takes a minute to dump out via a slow console. The hex output
is much more compact and faster to dump.

Actual tracing or wireshark kind of capability would come via decoding
the ftrace log. When enabled, everything that is written to the channel,
is also written to ftrace.

>>>> +static void show_channel_word(struct output *o, int *state, int *count,
>>>> +		u32 addr, u32 val, struct host1x_cdma *cdma)
>>>> +{
>>>> +	static int start_count, dont_print;
>>>
>>> What if two processes read debug information at the same time?
>>
>> show_channels() acquires cdma.lock, so that shouldn't happen.
> 
> Okay. Another solution would be to pass around a debug context which
> keeps track of the variables. But if we opt for a more involved dump
> interface as discussed above this will no longer be relevant.

Actually, debugging process needs cdma.lock, because it goes through the
cdma queue. Also command FIFO dumping is something that must be done by
a single thread at a time.

> Okay. In the context of a channel dump interface this may not be
> relevant anymore. Can you think of any issue that wouldn't be detectable
> or debuggable by analyzing a binary dump of the data within a channel?
> I'm asking because at that point we wouldn't be able to access any of
> the in-kernel data structures but would have to rely on the data itself
> for diagnostics. IOMMU virtual addresses won't be available and so on.

In many cases, looking at syncpt values, and channel state
(active/waiting on a syncpt, etc) gives an indication on what is the
current state of hardware. But, very often problems are ripple effects
on something that happened earlier and the job that caused the problem
has already been freed and is not visible in the dump.

To get a full history, we need often need the ftrace log.

Terje
