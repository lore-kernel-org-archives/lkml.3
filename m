Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaAXSlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:41:12 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:56796 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaAXSlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:41:09 -0500
MIME-Version: 1.0
In-Reply-To: <CAMrG31whcQp1YRwrYsgj2xT+gMcLYPA3T0cHyd5Ujnryempycw@mail.gmail.com>
References: <CAMrG31x0H1OjtNfdcXq2EqZ20XPHCX8qvrQSSuMqR=hsttYmXQ@mail.gmail.com>
 <20140122152239.GA11404@stefanha-thinkpad.redhat.com> <CAMrG31w_M27m2D09_69giqJk_Hy3YnA4Vq91Yhphpvb0u2sNAw@mail.gmail.com>
 <52E08915.9070007@redhat.com> <CAMrG31whcQp1YRwrYsgj2xT+gMcLYPA3T0cHyd5Ujnryempycw@mail.gmail.com>
From: Alejandro Comisario <alejandro.comisario@mercadolibre.com>
Date: Fri, 24 Jan 2014 15:40:48 -0300
Message-ID: <CAMrG31z_Y9tdxGXOjEah_hBfeKWjakJWJ4=k8T7t4mbq-pJxNA@mail.gmail.com>
Subject: Re: kvm virtio ethernet ring on guest side over high throughput
 (packet per second)
To: Jason Wang <jasowang@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, its confirmed that ... because of the shape of our traffic,
constant burst of many many small packages (1.5k / 3.5k) Nagle
algorithm was in a beggining the root cause of our performance issues.

So i will have this thread as solved.
Thank you so much to everyone involved, specially people from RedHat.
Thanks a lot!


Alejandro Comisario
#melicloud CloudBuilders
Arias 3751, Piso 7 (C1430CRG)
Ciudad de Buenos Aires - Argentina
Cel: +549(11) 15-3770-1857
Tel : +54(11) 4640-8443


On Thu, Jan 23, 2014 at 4:25 PM, Alejandro Comisario
<alejandro.comisario@mercadolibre.com> wrote:
> Jason, Stefan ... thank you so much.
> At a glance, disabling Nagle algorithm made the hundred thousands
> "20ms" delays to dissapear suddenly, tomorrow we are gonna made a
> "whole day" test again, and test client connectivity against "NginX
> and Memcached" to see if, because of the traffic we have (hundred
> thousands packages per minute) Nagle introduced this delay.
>
> I'll get back to you tomorrow with the tests.
> Thanks again.
>
> kindest regards.
>
>
> Alejandro Comisario
> #melicloud CloudBuilders
> Arias 3751, Piso 7 (C1430CRG)
> Ciudad de Buenos Aires - Argentina
> Cel: +549(11) 15-3770-1857
> Tel : +54(11) 4640-8443
>
>
> On Thu, Jan 23, 2014 at 12:14 AM, Jason Wang <jasowang@redhat.com> wrote:
>> On 01/23/2014 05:32 AM, Alejandro Comisario wrote:
>>> Thank you so much Stefan for the help and cc'ing Michael & Jason.
>>> Like you advised yesterday on IRC, today we are making some tests with
>>> the application setting TCP_NODELAY in the socket options.
>>>
>>> So we will try that and get back to you with further information.
>>> In the mean time, maybe showing what options the vms are using while running !
>>>
>>> # ------------------------------------------------------------------------------------------------------------------------------------------------------------------
>>> /usr/bin/kvm -S -M pc-1.0 -cpu
>>> core2duo,+lahf_lm,+rdtscp,+pdpe1gb,+aes,+popcnt,+x2apic,+sse4.2,+sse4.1,+dca,+xtpr,+cx16,+tm2,+est,+vmx,+ds_cpl,+pbe,+tm,+ht,+ss,+acpi,+ds
>>> -enable-kvm -m 32768 -smp 8,sockets=1,cores=6,threads=2 -name
>>> instance-00000254 -uuid d25b1b20-409e-4d7f-bd92-2ef4073c7c2b
>>> -nodefconfig -nodefaults -chardev
>>> socket,id=charmonitor,path=/var/lib/libvirt/qemu/instance-00000254.monitor,server,nowait
>>> -mon chardev=charmonitor,id=monitor,mode=control -rtc base=utc
>>> -no-shutdown -kernel /var/lib/nova/instances/instance-00000254/kernel
>>> -initrd /var/lib/nova/instances/instance-00000254/ramdisk -append
>>> root=/dev/vda console=ttyS0 -drive
>>> file=/var/lib/nova/instances/instance-00000254/disk,if=none,id=drive-virtio-disk0,format=qcow2,cache=writethrough
>>> -device virtio-blk-pci,bus=pci.0,addr=0x4,drive=drive-virtio-disk0,id=virtio-disk0
>>> -netdev tap,fd=19,id=hostnet0 -device
>>
>> Better enable vhost as Stefan suggested. It may help a lot here.
>>> virtio-net-pci,netdev=hostnet0,id=net0,mac=fa:16:3e:27:d4:6d,bus=pci.0,addr=0x3
>>> -chardev file,id=charserial0,path=/var/lib/nova/instances/instance-00000254/console.log
>>> -device isa-serial,chardev=charserial0,id=serial0 -chardev
>>> pty,id=charserial1 -device isa-serial,chardev=charserial1,id=serial1
>>> -usb -device usb-tablet,id=input0 -vnc 0.0.0.0:4 -k en-us -vga cirrus
>>> -device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x5
>>> # ------------------------------------------------------------------------------------------------------------------------------------------------------------------
>>>
>>> best regards
>>>
>>>
>>> Alejandro Comisario
>>> #melicloud CloudBuilders
>>> Arias 3751, Piso 7 (C1430CRG)
>>> Ciudad de Buenos Aires - Argentina
>>> Cel: +549(11) 15-3770-1857
>>> Tel : +54(11) 4640-8443
>>>
>>>
>>> On Wed, Jan 22, 2014 at 12:22 PM, Stefan Hajnoczi <stefanha@gmail.com> wrote:
>>>> On Tue, Jan 21, 2014 at 04:06:05PM -0200, Alejandro Comisario wrote:
>>>>
>>>> CCed Michael Tsirkin and Jason Wang who work on KVM networking.
>>>>
>>>>> Hi guys, we had in the past when using physical servers, several
>>>>> throughput issues regarding the throughput of our APIS, in our case we
>>>>> measure this with packets per seconds, since we dont have that much
>>>>> bandwidth (Mb/s) since our apis respond lots of packets very small
>>>>> ones (maximum response of 3.5k and avg response of 1.5k), when we
>>>>> where using this physical servers, when we reach throughput capacity
>>>>> (due to clients tiemouts) we touched the ethernet ring configuration
>>>>> and we made the problem dissapear.
>>>>>
>>>>> Today with kvm and over 10k virtual instances, when we want to
>>>>> increase the throughput of KVM instances, we bumped with the fact that
>>>>> when using virtio on guests, we have a max configuration of the ring
>>>>> of 256 TX/RX, and from the host side the atached vnet has a txqueuelen
>>>>> of 500.
>>>>>
>>>>> What i want to know is, how can i tune the guest to support more
>>>>> packets per seccond if i know that's my bottleneck?
>>>> I suggest investigating performance in a systematic way.  Set up a
>>>> benchmark that saturates the network.  Post the details of the benchmark
>>>> and the results that you are seeing.
>>>>
>>>> Then, we can discuss how to investigate the root cause of the bottleneck.
>>>>
>>>>> * does virtio exposes more packets to configure in the virtual ethernet's ring ?
>>>> No, ring size is hardcoded in QEMU (on the host).
>>>>
>>>>> * does the use of vhost_net helps me with increasing packets per
>>>>> second and not only bandwidth?
>>>> vhost_net is generally the most performant network option.
>>>>
>>>>> does anyone has to struggle with this before and knows where i can look into ?
>>>>> there's LOOOOOOOOOOOOOOOTS of information about networking performance
>>>>> tuning of kvm, but nothing related to increase throughput in pps
>>>>> capacity.
>>>>>
>>>>> This is a couple of configurations that we are having right now on the
>>>>> compute nodes:
>>>>>
>>>>> * 2x1Gb bonded interfaces (want to know the more than 20 models we are
>>>>> using, just ask for it)
>>>>> * Multi queue interfaces, pined via irq to different cores
>>>>> * Linux bridges,  no VLAN, no open-vswitch
>>>>> * ubuntu 12.04 kernel 3.2.0-[40-48]
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
