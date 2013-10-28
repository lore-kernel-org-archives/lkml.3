Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab3J1RDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:03:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516Ab3J1RDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:03:17 -0400
Message-ID: <526E98AF.10300@redhat.com>
Date: Mon, 28 Oct 2013 13:02:39 -0400
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
References: <201310181742.r9IHgO1q021001@ib.usersys.redhat.com> <20131019082314.GA7778@gmail.com> <52656A5A.4030406@redhat.com> <20131026115505.GB24067@gmail.com>
In-Reply-To: <20131026115505.GB24067@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="s2ko26uEAapCSIlh9km215RDWT3Fpuqxp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s2ko26uEAapCSIlh9km215RDWT3Fpuqxp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/26/2013 07:55 AM, Ingo Molnar wrote:
>
> * Doug Ledford <dledford@redhat.com> wrote:
>
>>> What I was objecting to strongly here was to measure the _wrong_
>>> thing, i.e. the cache-hot case. The cache-cold case should be
>>> measured in a low noise fashion, so that results are
>>> representative. It's closer to the real usecase than any other
>>> microbenchmark. That will give us a usable speedup figure and
>>> will tell us which technique helped how much and which parameter
>>> should be how large.
>>
>> Cold cache, yes.  Low noise, yes.  But you need DMA traffic at the
>> same time to be truly representative.
>
> Well, but in most usecases network DMA traffic is an order of
> magnitude smaller than system bus capacity. 100 gigabit network
> traffic is possible but not very common.

That's not necessarily true.  For gigabit, that's true.  For something
faster, even just 10GigE, it's not.  At least not when you consider that
network traffic usually involves hitting the bus at least two times, and
up to four times, depending on how it's processed on receive and whether
it goes cold from cache between accesses (once for the DMA from card to
memory, once for csum_partial so we know if the packet was good, and a
third time in copy_to_user so the user application can do something with
it, and possibly a fourth time if the user space application does
something with it).

> So I'd say that _if_ prefetching helps in the typical case we should
> tune it for that - not for the bus-contended case...

Well, I've been running a lot of tests here on various optimizations.
Some have helped, some not so much.  But I haven't been doing
micro-benchmarks like Neil.  I've been focused on running netperf over
IPoIB interfaces.  That should at least mimic real use somewhat and be
likely more indicitave of what the change will do to the system as a
whole than a micro-benchmark will.

I have a number of test systems, and they have a matrix of three
combinations of InfiniBand link speed and PCI-e bus speed that change
the theoretical max for each system.

For the 40GBit/s InfiniBand, the theoretical max throughput is 4GByte/s
(10/8bit wire encoding, not bothering to account for headers and such).

For the 56GBit/s InfiniBand, the theoretical max throughput is ~7GByte/s
(66/64 bit wire encoding).

For the PCI-e gen2 system, the PCI-e theoretical limit is 40GBit/s, for
the PCI-e gen3 systems the PCI-e theoretical limit is 64GBit/s. However,
with a max PCI-e payload of 128 bytes, the PCI-e gen2 bus will
definitely be a bottleneck before the 56GBit/s InfiniBand link.  The
PCI-e gen3 busses are probably right on par with a 56GBit/s InfiniBand
link in terms of max possible throughput.

Here are my test systems:

A - 2 Dell PowerEdge R415 AMD based servers, dual quad core processors
at 2.6GHz, 2MB L2, 5MB L3 cache, 32GB DDR3 1333 RAM, 56GBit/s InfiniBand
link speed on a card in a PCI-e Gen2 slot.  Results of base performance
bandwidth test:

[root@rdma-dev-00 ~]# qperf -t 15 ib0-dev-01 rc_bw rc_bi_bw
rc_bw:
    bw  =3D  2.93 GB/sec
rc_bi_bw:
    bw  =3D  5.5 GB/sec


B - 2 HP DL320e Gen8 servers, single Intel quad core Intel(R) Xeon(R)
CPU E3-1240 V2 @ 3.40GHz, 8GB DDR3 1600 RAM, card in PCI-e Gen3 slot
(8GT/s x8 active config).  Results of base performance bandwidth test
(40GBit/s link):

[root@rdma-qe-10 ~]# qperf -t 15 ib1-qe-11 rc_bw rc_bi_bw
rc_bw:
    bw  =3D  3.55 GB/sec
rc_bi_bw:
    bw  =3D  6.75 GB/sec


C - 2 HP DL360p Gen8 servers, dual Intel 8-core Intel(R) Xeon(R) CPU
E5-2660 0 @ 2.20GHz, 32GB DDR3 1333 RAM, card in PCI-e Gen3 slot (8GT/s
x8 active config).  Results of base performance bandwidth test (56GBit/s
link):

[root@rdma-perf-00 ~]# qperf -t 15 ib0-perf-01 rc_bw rc_bi_bw
rc_bw:
    bw  =3D  5.87 GB/sec
rc_bi_bw:
    bw  =3D  12.3 GB/sec


Some of my preliminary results:

1) Regarding the initial claim that changing the code to have two
addition chains, allowing the use of two ALUs, doubling performance: I'm
just not seeing it.  I have a number of theories about this, but they
are dependent on point #2 below:

2) Prefetch definitely helped, although how much depends on which of the
test setups I was using above.  The biggest gainer was B) the E3-1240 V2
@ 3.40GHz based machines.

So, my theories about #1 are that, with modern CPUs, it's more our
load/store speed that is killing us than the ALU speed.  I tried at
least 5 distinctly different ALU algorithms, including one that
eliminated the use of the carry chain entirely, and none of them had a
noticeable effect.  On the other hand, prefetch always had a noticeable
effect.  I suspect the original patch worked and had a performance
benefit some time ago due to a quirk on some CPU common back then, but
modern CPUs are capable of optimizing the routine well enough that the
benefit of the patch is already in our original csum routine due to CPU
optimizations.  Or maybe there is another explanation, but I'm not
really looking too hard for it.

I also tried two different prefetch methods on the theory that memory
access cycles are more important than CPU access cycles, and there
appears to be a minor benefit to wasting CPU cycles to prevent
unnecessary prefetches, even with 65520 as our MTU where a 320 byte
excess prefetch at the end of the operation only caused us to load a few
% points of extra memory.  I suspect that if I dropped the MTU down to
9K (to mimic jumbo frames on a device without tx/rx checksum offloads),
the smart version of prefetch would be a much bigger winner.  The fact
that there is any apparent difference at all on such a large copy tells
me that prefetch should probably always be smart and never dumb (and
here by smart versus dumb I mean prefetch should check to make sure you
aren't prefetching beyond the end of data you care about before
executing the prefetch instruction).

What I've found probably warrants more experimentation on the optimum
prefetch methods.  I also have another idea on speeding up the ALU
operations that I want to try.  So I'm not ready to send off everything
I have yet (and people wouldn't want that anyway, my collected data set
is megabytes in size).  But just to demonstrate some of what I'm seeing
here (notes: Recv CPU% of 12.5% is one CPU core pegged to 100% usage for
the A and B systems, for the C systems 3.125% is 100% usage for one CPU
core.  Also, although not so apparent on the AMD CPUs, the odd runs are
all with perf record, the even runs are with perf stat, and perf record
causes the odd runs to generally have a lower throughput (and this
effect is *huge* on the Intel 8 core CPUs, fully cutting throughput in
half on those systems)):

For the A systems:
Stock kernel:
            Utilization       Service Demand
            Send     Recv     Send    Recv
Throughput  local    remote   local   remote
MBytes  /s  % S      % S      us/KB   us/KB
  1082.47   3.69     12.55    0.266   0.906
  1087.64   3.46     12.52    0.249   0.899
  1104.43   3.52     12.53    0.249   0.886
  1090.37   3.68     12.51    0.264   0.897
  1078.73   3.13     12.56    0.227   0.910
  1091.88   3.63     12.52    0.259   0.896

With ALU patch:
            Utilization       Service Demand
            Send     Recv     Send    Recv
Throughput  local    remote   local   remote
MBytes  /s  % S      % S      us/KB   us/KB
  1075.01   3.70     12.53    0.269   0.911
  1116.90   3.86     12.53    0.270   0.876
  1073.40   3.67     12.54    0.267   0.913
  1092.79   3.83     12.52    0.274   0.895
  1108.69   2.98     12.56    0.210   0.885
  1116.76   2.66     12.51    0.186   0.875

With ALU patch + 5*64 smart prefetch:
            Utilization       Service Demand
            Send     Recv     Send    Recv
Throughput  local    remote   local   remote
MBytes  /s  % S      % S      us/KB   us/KB
  1243.05   4.63     12.60    0.291   0.792
  1194.70   5.80     12.58    0.380   0.822
  1149.15   4.09     12.57    0.278   0.854
  1207.21   5.69     12.53    0.368   0.811
  1204.07   4.27     12.57    0.277   0.816
  1191.04   4.78     12.60    0.313   0.826


For the B systems:
Stock kernel:
            Utilization       Service Demand
            Send     Recv     Send    Recv
Throughput  local    remote   local   remote
MBytes  /s  % S      % S      us/KB   us/KB
  2778.98   7.75     12.34    0.218   0.347
  2819.14   7.31     12.52    0.203   0.347
  2721.43   8.43     12.19    0.242   0.350
  2832.93   7.38     12.58    0.203   0.347
  2770.07   8.01     12.27    0.226   0.346
  2829.17   7.27     12.51    0.201   0.345

With ALU patch:
            Utilization       Service Demand
            Send     Recv     Send    Recv
Throughput  local    remote   local   remote
MBytes  /s  % S      % S      us/KB   us/KB
  2801.36   8.18     11.97    0.228   0.334
  2927.81   7.52     12.51    0.201   0.334
  2808.32   8.62     11.98    0.240   0.333
  2918.12   7.20     12.54    0.193   0.336
  2730.00   8.85     11.60    0.253   0.332
  2932.17   7.37     12.51    0.196   0.333

With ALU patch + 5*64 smart prefetch:
            Utilization       Service Demand
            Send     Recv     Send    Recv
Throughput  local    remote   local   remote
MBytes  /s  % S      % S      us/KB   us/KB
  3029.53   9.34     10.67    0.241   0.275
  3229.36   7.81     11.65    0.189   0.282  <- this is a saturated
                                           40GBit/s InfiniBand link,
                                           and the recv CPU is no longer
                                           pegged at 100%, so the gains
                                           here are higher than just the
                                           throughput gains suggest
  3161.14   8.24     11.10    0.204   0.274
  3171.78   7.80     11.89    0.192   0.293
  3134.01   8.35     10.99    0.208   0.274
  3235.50   7.75     11.57    0.187   0.279  <- ditto here

For the C systems:
Stock kernel:
            Utilization       Service Demand
            Send     Recv     Send    Recv
Throughput  local    remote   local   remote
MBytes  /s  % S      % S      us/KB   us/KB
  1091.03   1.59     3.14     0.454   0.900
  2299.34   2.57     3.07     0.350   0.417
  1177.07   1.71     3.15     0.455   0.838
  2312.59   2.54     3.02     0.344   0.408
  1273.94   2.03     3.15     0.499   0.772
  2591.50   2.76     3.19     0.332   0.385

With ALU patch:
            Utilization       Service Demand
            Send     Recv     Send    Recv
Throughput  local    remote   local   remote
MBytes  /s  % S      % S      us/KB   us/KB
  Data for this series is missing (these machines were added to
  the matrix late and this kernel had already been rebuilt to
  something else and was no longer installable...I could recreate
  this if people really care).

With ALU patch + 5*64 smart prefetch:
            Utilization       Service Demand
            Send     Recv     Send    Recv
Throughput  local    remote   local   remote
MBytes  /s  % S      % S      us/KB   us/KB
  1377.03   2.05     3.13     0.466   0.711
  2002.30   2.40     3.04     0.374   0.474
  1470.18   2.25     3.13     0.479   0.666
  1994.96   2.44     3.08     0.382   0.482
  1167.82   1.72     3.14     0.461   0.840
  2004.49   2.46     3.06     0.384   0.477

What strikes me as important here is that these 8 core Intel CPUs
actually got *slower* with the ALU patch + prefetch.  This warrants more
investigation to find out if it's the prefetch or the ALU patch that did
the damage to the speed.  It's also worth noting that these 8 core CPUs
have such high variability that I don't trust these measurements yet.

>>> More importantly, the 'maximally adversarial' case is very hard
>>> to generate, validate, and it's highly system dependent!
>>
>> This I agree with 100%, which is why I tend to think we should
>> scrap the static prefetch optimizations entirely and have a boot
>> up test that allows us to find our optimum prefetch distance for
>> our given hardware.
>
> Would be interesting to see.
>
> I'm a bit sceptical - I think 'looking 1-2 cachelines in advance' is
> something that might work reasonably well on a wide range of
> systems, while trying to find a bus capacity/latency dependent sweet
> spot would be difficult.

I think 1-2 cachelines is probably way too short.  Measuring the length
of time that we stall when accessing memory for the first time and then
comparing that to operation cycles for typical instruction chains would
give us more insight I think.  That or just tinkering with numbers and
seeing where things work best (but not just on static tests, under a
variety of workloads).

> We had pretty bad experience from boot-time measurements, and it's
> not for lack of trying: I implemented the raid algorithm
> benchmarking thing and also the scheduler's boot time cache-size
> probing, both were problematic and have hurt reproducability and
> debuggability.

OK, that's it from me for now, off to run more tests and try more things.=
=2E.


--s2ko26uEAapCSIlh9km215RDWT3Fpuqxp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSbpi3AAoJELgmozMOVy/dUXoQAKT3hTp8DGEk9wTJfzWB/k0E
L0ImdBpYHMdyEthB9TRXJsQB9wAQozbGnEIP9Q5wi7j9gGaSDStRYBVN+BSjI4lt
h/PHD7Xbxzex8BmAe8R75lb+ySrmgDCmW7AhwmrCknppFC0T2iTLS7VSiEB4Se7e
sxLGBPEkQxYkaSuZZEYvj9KizFzGTXPGLLMbxsBydB2v1Z0im49OzduSlk4iSgxd
BQK/1AhbsvBDzqBMQDtEVAXFSRVryQSNBNcUImQiBQdglrkoWoTuVpznjLWoDJKb
SOHI9jijByJhf42zDxw5mWm0k6HIPDIZug1joD0LIuvA9XfSO5vsonfwBBuXDHUJ
8pYqXjBjdqQ7mBV1H1uQCY/Z3nD3vjb97PLo2azlEEQSWY8BsfWuVWKZI2F+mKPJ
cC1bXit5Obh9FyNzM7ahUWD6/MOHW0LbAVMREg6cL1S2n/l8oCtzI57qOyp7SqWt
Y3Aysjyco9Q21bIK+teqMAFBREUE+me3eu4+jY8g8sYWJg/K2WnzzNAZ0owk9brL
By4kagqQ+ljd2qDLGtyH1y5Zq4O9HrcxlQV1nfBTht8Qxjsfnphst99WmVtVcrTU
AH1XYjrlQHelPvyZclRDoLaUjWZILdRcd9gNh5n7jYh5JDDEgRdk/v3bfvBeapVO
vobTdOGl1tEbpMvYpoWx
=RQlu
-----END PGP SIGNATURE-----

--s2ko26uEAapCSIlh9km215RDWT3Fpuqxp--
