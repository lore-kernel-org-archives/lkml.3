Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaAWDNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 22:13:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbaAWDNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 22:13:20 -0500
Message-ID: <52E088B5.8070401@redhat.com>
Date: Thu, 23 Jan 2014 11:12:53 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>,
        Alejandro Comisario <alejandro.comisario@mercadolibre.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: kvm virtio ethernet ring on guest side over high throughput (packet
 per second)
References: <CAMrG31x0H1OjtNfdcXq2EqZ20XPHCX8qvrQSSuMqR=hsttYmXQ@mail.gmail.com> <20140122152239.GA11404@stefanha-thinkpad.redhat.com>
In-Reply-To: <20140122152239.GA11404@stefanha-thinkpad.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 11:22 PM, Stefan Hajnoczi wrote:
> On Tue, Jan 21, 2014 at 04:06:05PM -0200, Alejandro Comisario wrote:
>
> CCed Michael Tsirkin and Jason Wang who work on KVM networking.
>
>> Hi guys, we had in the past when using physical servers, several
>> throughput issues regarding the throughput of our APIS, in our case we
>> measure this with packets per seconds, since we dont have that much
>> bandwidth (Mb/s) since our apis respond lots of packets very small
>> ones (maximum response of 3.5k and avg response of 1.5k), when we
>> where using this physical servers, when we reach throughput capacity
>> (due to clients tiemouts) we touched the ethernet ring configuration
>> and we made the problem dissapear.
>>
>> Today with kvm and over 10k virtual instances, when we want to
>> increase the throughput of KVM instances, we bumped with the fact that
>> when using virtio on guests, we have a max configuration of the ring
>> of 256 TX/RX, and from the host side the atached vnet has a txqueuelen
>> of 500.
>>
>> What i want to know is, how can i tune the guest to support more
>> packets per seccond if i know that's my bottleneck?
> I suggest investigating performance in a systematic way.  Set up a
> benchmark that saturates the network.  Post the details of the benchmark
> and the results that you are seeing.
>
> Then, we can discuss how to investigate the root cause of the bottleneck.
>
>> * does virtio exposes more packets to configure in the virtual ethernet's ring ?
> No, ring size is hardcoded in QEMU (on the host).

Do it make sense to let user can configure it through something at least
like qemu command line?
>
>> * does the use of vhost_net helps me with increasing packets per
>> second and not only bandwidth?
> vhost_net is generally the most performant network option.
>
>> does anyone has to struggle with this before and knows where i can look into ?
>> there's LOOOOOOOOOOOOOOOTS of information about networking performance
>> tuning of kvm, but nothing related to increase throughput in pps
>> capacity.
>>
>> This is a couple of configurations that we are having right now on the
>> compute nodes:
>>
>> * 2x1Gb bonded interfaces (want to know the more than 20 models we are
>> using, just ask for it)
>> * Multi queue interfaces, pined via irq to different cores

Maybe you can have a try with multiqueue virtio-net with vhost. It can
let guest to use more than one tx/rx virtqueue pairs to do the network
processing.
>> * Linux bridges,  no VLAN, no open-vswitch
>> * ubuntu 12.04 kernel 3.2.0-[40-48]

