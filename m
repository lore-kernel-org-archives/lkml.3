Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbaD3Uwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:52:39 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:40697 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759310AbaD3Uwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:52:38 -0400
X-Google-Original-From: Andy Lutomirski <luto@mit.edu>
Message-ID: <53616293.3080308@mit.edu>
Date: Wed, 30 Apr 2014 13:52:35 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Florian Weimer <fweimer@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random: Add "initialized" variable to proc
References: <20140428195913.E0A0143994596@oldenburg.str.redhat.com> <20140428214112.GC7857@thunk.org> <535FE68C.8060002@redhat.com> <20140429182610.GA19325@thunk.org>
In-Reply-To: <20140429182610.GA19325@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 11:26 AM, Theodore Ts'o wrote:
> On Tue, Apr 29, 2014 at 07:51:08PM +0200, Florian Weimer wrote:
>>
>> I've got a (physical) machine where it happens after ten seconds, or much
>> longer if there is no activity.
>>
>> I've seen cases where on the first boot of virtual machines, the SSH key was
>> generated before the printk with the initialization message.  It's not a
>> problem if you install the OS first and then generate the keys, but for
>> booting from pre-provisioned images, it could be.  (I have no evidence that
>> this hurts the quality of the generated key material, this is just based on
>> what's reported by the kernel.)
> 
> Yes, fair enough, just because it works for me for my laptops doesn't
> mean that there aren't systems for which it was a problem.  :-)
> 
> I will say that for virtual machines, we *really* need virtio-rng.

I only sort of agree.  I think that for VMs, we really need a good way
to provide an initial seed and ongoing entropy, and virtio-rng isn't it.

IMO virtio-rng is, alas, terminally fscked up.  It has four issues, all
show-stopping.  Fixing them may be impossible without changing the
interface.

1. It simply doesn't work on my system.  In particular, it never returns
entropy.  It just blocks forever.

2. The hwrng code sucks and the guest will never boot if there's a
non-working virtio-rng device around.  See #1.  I *may* get around to
writing a patch for this before the next merge window.

3. There should be a way to provide some entropy-free cryptographically
secure data, too.  Regardless of the speed of the hosts's /dev/random,
the guest should start with at least 256 bits of cryptographically
secure seed material IMO.

4. virtio-pci and its asynchronous interface are too complicated to
achieve #3, even if a future virtio-rng enhancement could provide
urandom-like data.  This thing is paravirt hardware; it should be able
to provide a seed *really* early.

--Andy
