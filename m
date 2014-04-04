Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaDDNWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 09:22:22 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57025 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaDDNWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:22:20 -0400
Message-ID: <533EB207.1020203@monstr.eu>
Date: Fri, 04 Apr 2014 15:22:15 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 09/20] of/fdt: create common debugfs
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com> <1396563423-30893-10-git-send-email-robherring2@gmail.com> <533EA2B0.7080703@monstr.eu> <CAL_JsqKFK8YDoODYKg5b8SmDzqdNSS6UvYr3_atzhcL2uR-=rA@mail.gmail.com>
In-Reply-To: <CAL_JsqKFK8YDoODYKg5b8SmDzqdNSS6UvYr3_atzhcL2uR-=rA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="A0miHcxEWMCXSruAF402wMfnfKlSLUv4S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A0miHcxEWMCXSruAF402wMfnfKlSLUv4S
Content-Type: multipart/mixed;
 boundary="------------040208070306000709060500"

This is a multi-part message in MIME format.
--------------040208070306000709060500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/04/2014 03:00 PM, Rob Herring wrote:
> On Fri, Apr 4, 2014 at 7:16 AM, Michal Simek <monstr@monstr.eu> wrote:
>> On 04/04/2014 12:16 AM, Rob Herring wrote:
>>> From: Rob Herring <robh@kernel.org>
>>>
>>> Both powerpc and microblaze have the same FDT blob in debugfs feature=
=2E
>>> Move this to common location and remove the powerpc and microblaze
>>> implementations. This feature could become more useful when FDT
>>> overlay support is added.
>>>
>>> This changes the path of the blob from "$arch/flat-device-tree" to
>>> "device-tree/flat-device-tree".
>=20
> [snip]
>=20
>>> -#if defined(CONFIG_DEBUG_FS) && defined(DEBUG)
>>> -static struct debugfs_blob_wrapper flat_dt_blob;
>>> -
>>> -static int __init export_flat_device_tree(void)
>>> -{
>>> -     struct dentry *d;
>>> -
>>> -     flat_dt_blob.data =3D initial_boot_params;
>>> -     flat_dt_blob.size =3D initial_boot_params->totalsize;
>>
>> As I see even microblaze version was buggy.
>=20
> How so?

if you compare it with powerpc version here is missing
be to cpu conversion.

>=20
>> ...
>>
>>> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
>>> index fa16a91..2085d47 100644
>>> --- a/drivers/of/fdt.c
>>> +++ b/drivers/of/fdt.c
>>> @@ -20,6 +20,7 @@
>>>  #include <linux/string.h>
>>>  #include <linux/errno.h>
>>>  #include <linux/slab.h>
>>> +#include <linux/debugfs.h>
>>>
>>>  #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
>>>  #ifdef CONFIG_PPC
>>> @@ -1084,4 +1085,27 @@ void __init unflatten_and_copy_device_tree(voi=
d)
>>>       unflatten_device_tree();
>>>  }
>>>
>>> +#if defined(CONFIG_DEBUG_FS) && defined(DEBUG)
>>> +static struct debugfs_blob_wrapper flat_dt_blob;
>>> +
>>> +static int __init of_flat_dt_debugfs_export_fdt(void)
>>> +{
>>> +     struct dentry *d =3D debugfs_create_dir("device-tree", NULL);
>>> +
>>> +     if (!d)
>>> +             return -ENOENT;
>>> +
>>> +     flat_dt_blob.data =3D initial_boot_params;
>>> +     flat_dt_blob.size =3D fdt_totalsize(initial_boot_params);
>>
>> Have you tried to compile this?
>>
>> From my tests fdt_totalsize is not available for target just for host
>> from libfdt.h
>>
>> drivers/of/fdt.c: In function 'of_flat_dt_debugfs_export_fdt':
>> drivers/of/fdt.c:957:2: error: implicit declaration of function 'fdt_t=
otalsize' [-Werror=3Dimplicit-function-declaration]
>=20
> Ah, it needs to be re-ordered after the libfdt conversion when
> libfdt.h gets added.

I just pick some of them not all of them and send email. :-(

Anyway I am testing it for microblaze and getting problem
caused by this patch:
commit 3d2ee8571ac0580d49c3f41fa28336289934900a
Author: Rob Herring <robh@kernel.org>
Date:   Wed Apr 2 15:10:14 2014 -0500

    of/fdt: Convert FDT functions to use libfdt

And reason is that in unflatten_dt_node()

pathp =3D fdt_get_name(blob, *poffset, &l);

is returning NULL
and here
	/* version 0x10 has a more compact unit name here instead of the full
	 * path. we accumulate the full path size using "fpsize", we'll rebuild
	 * it later. We detect this because the first character of the name is
	 * not '/'.
	 */
	if ((*pathp) !=3D '/') {

code is trying to read it which is causing this kernel bug:
Oops: kernel access of bad area, sig: 11

It means fdt_next_node(is doing something wrong)

Any easy way how to debug it?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform


--------------040208070306000709060500
Content-Type: text/plain; charset=UTF-8;
 name="system.dts"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="system.dts"

/*
 * Device Tree Generator version: 1.1
 *
 * (C) Copyright 2007-2013 Xilinx, Inc.
 * (C) Copyright 2007-2013 Michal Simek
 * (C) Copyright 2007-2012 PetaLogix Qld Pty Ltd
 *
 * Michal SIMEK <monstr@monstr.eu>
 *
 * CAUTION: This file is automatically generated by libgen.
 * Version: Xilinx EDK 2013.3 EDK_P.20131013
 * Today is: Thursday, the 21 of November, 2013; 19:47:51
 *
 * XPS project directory: .
 */

/dts-v1/;
/ {
	#address-cells =3D <1>;
	#size-cells =3D <1>;
	compatible =3D "xlnx,microblaze";
	hard-reset-gpios =3D <&reset_gpio 0 1>;
	model =3D ".";
	aliases {
		ethernet0 =3D &axi_ethernet_eth_buf;
		serial0 =3D &rs232_uart;
	} ;
	chosen {
		bootargs =3D "console=3DttyS0,115200 earlyprintk";
		linux,stdout-path =3D "/axi@0/serial@40400000";
	} ;
	cpus {
		#address-cells =3D <1>;
		#cpus =3D <0x1>;
		#size-cells =3D <0>;
		microblaze_0: cpu@0 {
			bus-handle =3D <&microblaze_0_axi_periph_xbar>;
			clock-frequency =3D <100000000>;
			compatible =3D "xlnx,microblaze-9.2";
			d-cache-baseaddr =3D <0x80000000>;
			d-cache-highaddr =3D <0xbfffffff>;
			d-cache-line-size =3D <0x20>;
			d-cache-size =3D <0x4000>;
			device_type =3D "cpu";
			i-cache-baseaddr =3D <0x80000000>;
			i-cache-highaddr =3D <0xbfffffff>;
			i-cache-line-size =3D <0x10>;
			i-cache-size =3D <0x4000>;
			interrupt-handle =3D <&microblaze_0_axi_intc>;
			model =3D "microblaze,9.2";
			reg =3D <0>;
			timebase-frequency =3D <100000000>;
			xlnx,addr-tag-bits =3D <0x10>;
			xlnx,allow-dcache-wr =3D <0x1>;
			xlnx,allow-icache-wr =3D <0x1>;
			xlnx,area-optimized =3D <0x0>;
			xlnx,async-interrupt =3D <0x1>;
			xlnx,avoid-primitives =3D <0x0>;
			xlnx,base-vectors =3D <0x0>;
			xlnx,branch-target-cache-size =3D <0x0>;
			xlnx,cache-byte-size =3D <0x4000>;
			xlnx,d-axi =3D <0x1>;
			xlnx,d-lmb =3D <0x1>;
			xlnx,data-size =3D <0x20>;
			xlnx,dcache-addr-tag =3D <0x10>;
			xlnx,dcache-always-used =3D <0x1>;
			xlnx,dcache-byte-size =3D <0x4000>;
			xlnx,dcache-data-width =3D <0x0>;
			xlnx,dcache-force-tag-lutram =3D <0x0>;
			xlnx,dcache-line-len =3D <0x8>;
			xlnx,dcache-use-writeback =3D <0x1>;
			xlnx,dcache-victims =3D <0x0>;
			xlnx,debug-enabled =3D <0x1>;
			xlnx,div-zero-exception =3D <0x1>;
			xlnx,dynamic-bus-sizing =3D <0x0>;
			xlnx,ecc-use-ce-exception =3D <0x0>;
			xlnx,edge-is-positive =3D <0x0>;
			xlnx,enable-discrete-ports =3D <0x0>;
			xlnx,endianness =3D <0x1>;
			xlnx,fault-tolerant =3D <0x0>;
			xlnx,fpu-exception =3D <0x0>;
			xlnx,freq =3D <0x5f5e100>;
			xlnx,fsl-exception =3D <0x0>;
			xlnx,fsl-links =3D <0x0>;
			xlnx,i-axi =3D <0x0>;
			xlnx,i-lmb =3D <0x1>;
			xlnx,icache-always-used =3D <0x1>;
			xlnx,icache-data-width =3D <0x0>;
			xlnx,icache-force-tag-lutram =3D <0x0>;
			xlnx,icache-line-len =3D <0x4>;
			xlnx,icache-streams =3D <0x1>;
			xlnx,icache-victims =3D <0x8>;
			xlnx,ill-opcode-exception =3D <0x1>;
			xlnx,instance =3D "kc705_microblaze_0_0";
			xlnx,interconnect =3D <0x2>;
			xlnx,interrupt-is-edge =3D <0x0>;
			xlnx,lockstep-select =3D <0x0>;
			xlnx,lockstep-slave =3D <0x0>;
			xlnx,mmu-dtlb-size =3D <0x4>;
			xlnx,mmu-itlb-size =3D <0x2>;
			xlnx,mmu-privileged-instr =3D <0x0>;
			xlnx,mmu-tlb-access =3D <0x3>;
			xlnx,mmu-zones =3D <0x2>;
			xlnx,number-of-pc-brk =3D <0x1>;
			xlnx,number-of-rd-addr-brk =3D <0x0>;
			xlnx,number-of-wr-addr-brk =3D <0x0>;
			xlnx,opcode-0x0-illegal =3D <0x1>;
			xlnx,optimization =3D <0x0>;
			xlnx,pc-width =3D <0x20>;
			xlnx,pvr =3D <0x2>;
			xlnx,pvr-user1 =3D <0x0>;
			xlnx,pvr-user2 =3D <0x0>;
			xlnx,reset-msr =3D <0x0>;
			xlnx,sco =3D <0x0>;
			xlnx,trace =3D <0x0>;
			xlnx,unaligned-exceptions =3D <0x1>;
			xlnx,use-barrel =3D <0x1>;
			xlnx,use-branch-target-cache =3D <0x1>;
			xlnx,use-config-reset =3D <0x0>;
			xlnx,use-dcache =3D <0x1>;
			xlnx,use-div =3D <0x1>;
			xlnx,use-ext-brk =3D <0x0>;
			xlnx,use-ext-nm-brk =3D <0x0>;
			xlnx,use-extended-fsl-instr =3D <0x0>;
			xlnx,use-fpu =3D <0x0>;
			xlnx,use-hw-mul =3D <0x2>;
			xlnx,use-icache =3D <0x1>;
			xlnx,use-interrupt =3D <0x2>;
			xlnx,use-mmu =3D <0x3>;
			xlnx,use-msr-instr =3D <0x1>;
			xlnx,use-pcmp-instr =3D <0x1>;
			xlnx,use-reorder-instr =3D <0x1>;
			xlnx,use-stack-protection =3D <0x0>;
		} ;
	} ;
	ddr3_sdram: memory@80000000 {
		device_type =3D "memory";
		reg =3D <0x80000000 0x40000000>;
	} ;
	microblaze_0_axi_periph_xbar: axi@0 {
		#address-cells =3D <1>;
		#size-cells =3D <1>;
		compatible =3D "xlnx,axi-crossbar-2.1", "simple-bus";
		ranges ;
		axi_ethernet_dma: axi-dma@41e00000 {
			axistream-connected =3D <&axi_ethernet_eth_buf>;
			axistream-control-connected =3D <&axi_ethernet_eth_buf>;
			compatible =3D "xlnx,axi-dma-7.1", "xlnx,axi-dma-1.00.a";
			interrupt-parent =3D <&microblaze_0_axi_intc>;
			interrupts =3D <2 2>, <3 2>;
			reg =3D <0x41e00000 0x10000>;
			xlnx,dlytmr-resolution =3D <0x7d>;
			xlnx,enable-multi-channel =3D <0x0>;
			xlnx,include-mm2s =3D <0x1>;
			xlnx,include-mm2s-dre =3D <0x1>;
			xlnx,include-mm2s-sf =3D <0x1>;
			xlnx,include-s2mm =3D <0x1>;
			xlnx,include-s2mm-dre =3D <0x1>;
			xlnx,include-s2mm-sf =3D <0x1>;
			xlnx,include-sg =3D <0x1>;
			xlnx,micro-dma =3D <0x0>;
			xlnx,mm2s-burst-size =3D <0x10>;
			xlnx,num-mm2s-channels =3D <0x1>;
			xlnx,num-s2mm-channels =3D <0x1>;
			xlnx,prmry-is-aclk-async =3D <0x0>;
			xlnx,s2mm-burst-size =3D <0x10>;
			xlnx,sg-include-stscntrl-strm =3D <0x1>;
			xlnx,sg-length-width =3D <0xe>;
			xlnx,sg-use-stsapp-length =3D <0x1>;
		} ;
		axi_ethernet_eth_buf: axi-ethernet@44a00000 {
			axistream-connected =3D <&axi_ethernet_dma>;
			axistream-control-connected =3D <&axi_ethernet_dma>;
			clock-frequency =3D <100000000>;
			compatible =3D "xlnx,axi-ethernet-buffer-2.0", "xlnx,axi-ethernet-1.00=
=2Ea";
			device_type =3D "network";
			interrupt-parent =3D <&microblaze_0_axi_intc>;
			interrupts =3D <1 2>;
			local-mac-address =3D [ 00 0a 35 00 42 4a ];
			phy-handle =3D <&phy0>;
			reg =3D <0x44a00000 0x40000>;
			xlnx,avb =3D <0x0>;
			xlnx,halfdup =3D "1";
			xlnx,include-io =3D "1";
			xlnx,mcast-extend =3D <0x0>;
			xlnx,phy-type =3D <0x1>;
			xlnx,phyaddr =3D <0x1>;
			xlnx,rxcsum =3D <0x0>;
			xlnx,rxmem =3D <0x1000>;
			xlnx,rxvlan-strp =3D <0x0>;
			xlnx,rxvlan-tag =3D <0x0>;
			xlnx,rxvlan-tran =3D <0x0>;
			xlnx,stats =3D <0x0>;
			xlnx,txcsum =3D <0x0>;
			xlnx,txmem =3D <0x1000>;
			xlnx,txvlan-strp =3D <0x0>;
			xlnx,txvlan-tag =3D <0x0>;
			xlnx,txvlan-tran =3D <0x0>;
			xlnx,type =3D <0x1>;
			mdio {
				#address-cells =3D <1>;
				#size-cells =3D <0>;
				phy0: phy@7 {
					compatible =3D "marvell,88e1111";
					device_type =3D "ethernet-phy";
					reg =3D <7>;
				} ;
			} ;
		} ;
		axi_timer_0: system-timer@41c00000 {
			clock-frequency =3D <100000000>;
			compatible =3D "xlnx,axi-timer-2.0", "xlnx,xps-timer-1.00.a";
			interrupt-parent =3D <&microblaze_0_axi_intc>;
			interrupts =3D <0 2>;
			reg =3D <0x41c00000 0x10000>;
			xlnx,count-width =3D <0x20>;
			xlnx,gen0-assert =3D <0x1>;
			xlnx,gen1-assert =3D <0x1>;
			xlnx,one-timer-only =3D <0x0>;
			xlnx,trig0-assert =3D <0x1>;
			xlnx,trig1-assert =3D <0x1>;
		} ;
		dip_switches_4bits: gpio@40010000 {
			#gpio-cells =3D <2>;
			compatible =3D "xlnx,axi-gpio-2.0", "xlnx,xps-gpio-1.00.a";
			gpio-controller ;
			reg =3D <0x40010000 0x10000>;
			xlnx,all-inputs =3D <0x1>;
			xlnx,all-inputs-2 =3D <0x0>;
			xlnx,all-outputs =3D <0x0>;
			xlnx,all-outputs-2 =3D <0x0>;
			xlnx,dout-default =3D <0x0>;
			xlnx,dout-default-2 =3D <0x0>;
			xlnx,gpio-width =3D <0x4>;
			xlnx,gpio2-width =3D <0x20>;
			xlnx,interrupt-present =3D <0x0>;
			xlnx,is-dual =3D <0x0>;
			xlnx,tri-default =3D <0xffffffff>;
			xlnx,tri-default-2 =3D <0xffffffff>;
		} ;
		led_8bits: gpio@40020000 {
			#gpio-cells =3D <2>;
			compatible =3D "xlnx,axi-gpio-2.0", "xlnx,xps-gpio-1.00.a";
			gpio-controller ;
			reg =3D <0x40020000 0x10000>;
			xlnx,all-inputs =3D <0x0>;
			xlnx,all-inputs-2 =3D <0x0>;
			xlnx,all-outputs =3D <0x1>;
			xlnx,all-outputs-2 =3D <0x0>;
			xlnx,dout-default =3D <0x0>;
			xlnx,dout-default-2 =3D <0x0>;
			xlnx,gpio-width =3D <0x8>;
			xlnx,gpio2-width =3D <0x20>;
			xlnx,interrupt-present =3D <0x0>;
			xlnx,is-dual =3D <0x0>;
			xlnx,tri-default =3D <0xffffffff>;
			xlnx,tri-default-2 =3D <0xffffffff>;
		} ;
		microblaze_0_axi_intc: interrupt-controller@41200000 {
			#interrupt-cells =3D <0x2>;
			compatible =3D "xlnx,axi-intc-4.0", "xlnx,xps-intc-1.00.a";
			interrupt-controller ;
			reg =3D <0x41200000 0x10000>;
			xlnx,kind-of-intr =3D <0x0>;
			xlnx,num-intr-inputs =3D <0x5>;
		} ;
		primary_flash: flash@60000000 {
			#address-cells =3D <1>;
			#size-cells =3D <1>;
			bank-width =3D <2>;
			compatible =3D "xlnx,axi-emc-2.0", "cfi-flash";
			reg =3D <0x60000000 0x8000000>;
			xlnx,axi-clk-period-ps =3D <0x2710>;
			xlnx,include-datawidth-matching-0 =3D <0x1>;
			xlnx,include-datawidth-matching-1 =3D <0x1>;
			xlnx,include-datawidth-matching-2 =3D <0x1>;
			xlnx,include-datawidth-matching-3 =3D <0x1>;
			xlnx,include-negedge-ioregs =3D <0x0>;
			xlnx,instance =3D "axi_emc_inst";
			xlnx,lflash-period-ps =3D <0x4e20>;
			xlnx,linear-flash-sync-burst =3D <0x0>;
			xlnx,max-mem-width =3D <0x10>;
			xlnx,mem0-type =3D <0x2>;
			xlnx,mem0-width =3D <0x10>;
			xlnx,mem1-type =3D <0x2>;
			xlnx,mem1-width =3D <0x10>;
			xlnx,mem2-type =3D <0x2>;
			xlnx,mem2-width =3D <0x10>;
			xlnx,mem3-type =3D <0x2>;
			xlnx,mem3-width =3D <0x10>;
			xlnx,num-banks-mem =3D <0x1>;
			xlnx,parity-type-mem-0 =3D <0x0>;
			xlnx,parity-type-mem-1 =3D <0x0>;
			xlnx,parity-type-mem-2 =3D <0x0>;
			xlnx,parity-type-mem-3 =3D <0x0>;
			xlnx,s-axi-en-reg =3D <0x0>;
			xlnx,s-axi-mem-addr-width =3D <0x20>;
			xlnx,s-axi-mem-data-width =3D <0x20>;
			xlnx,s-axi-mem-id-width =3D <0x1>;
			xlnx,s-axi-reg-addr-width =3D <0x5>;
			xlnx,s-axi-reg-data-width =3D <0x20>;
			xlnx,synch-pipedelay-0 =3D <0x1>;
			xlnx,synch-pipedelay-1 =3D <0x1>;
			xlnx,synch-pipedelay-2 =3D <0x1>;
			xlnx,synch-pipedelay-3 =3D <0x1>;
			xlnx,tavdv-ps-mem-0 =3D <0x1fbd0>;
			xlnx,tavdv-ps-mem-1 =3D <0x3a98>;
			xlnx,tavdv-ps-mem-2 =3D <0x3a98>;
			xlnx,tavdv-ps-mem-3 =3D <0x3a98>;
			xlnx,tcedv-ps-mem-0 =3D <0x1fbd0>;
			xlnx,tcedv-ps-mem-1 =3D <0x3a98>;
			xlnx,tcedv-ps-mem-2 =3D <0x3a98>;
			xlnx,tcedv-ps-mem-3 =3D <0x3a98>;
			xlnx,thzce-ps-mem-0 =3D <0x1b58>;
			xlnx,thzce-ps-mem-1 =3D <0x1b58>;
			xlnx,thzce-ps-mem-2 =3D <0x1b58>;
			xlnx,thzce-ps-mem-3 =3D <0x1b58>;
			xlnx,thzoe-ps-mem-0 =3D <0x1b58>;
			xlnx,thzoe-ps-mem-1 =3D <0x1b58>;
			xlnx,thzoe-ps-mem-2 =3D <0x1b58>;
			xlnx,thzoe-ps-mem-3 =3D <0x1b58>;
			xlnx,tlzwe-ps-mem-0 =3D <0xc350>;
			xlnx,tlzwe-ps-mem-1 =3D <0x0>;
			xlnx,tlzwe-ps-mem-2 =3D <0x0>;
			xlnx,tlzwe-ps-mem-3 =3D <0x0>;
			xlnx,tpacc-ps-flash-0 =3D <0x61a8>;
			xlnx,tpacc-ps-flash-1 =3D <0x61a8>;
			xlnx,tpacc-ps-flash-2 =3D <0x61a8>;
			xlnx,tpacc-ps-flash-3 =3D <0x61a8>;
			xlnx,twc-ps-mem-0 =3D <0x3a98>;
			xlnx,twc-ps-mem-1 =3D <0x3a98>;
			xlnx,twc-ps-mem-2 =3D <0x3a98>;
			xlnx,twc-ps-mem-3 =3D <0x3a98>;
			xlnx,twp-ps-mem-0 =3D <0x13880>;
			xlnx,twp-ps-mem-1 =3D <0x2ee0>;
			xlnx,twp-ps-mem-2 =3D <0x2ee0>;
			xlnx,twp-ps-mem-3 =3D <0x2ee0>;
			xlnx,twph-ps-mem-0 =3D <0x13880>;
			xlnx,twph-ps-mem-1 =3D <0x2ee0>;
			xlnx,twph-ps-mem-2 =3D <0x2ee0>;
			xlnx,twph-ps-mem-3 =3D <0x2ee0>;
			xlnx,wr-rec-time-mem-0 =3D <0x186a0>;
			xlnx,wr-rec-time-mem-1 =3D <0x6978>;
			xlnx,wr-rec-time-mem-2 =3D <0x6978>;
			xlnx,wr-rec-time-mem-3 =3D <0x6978>;
			partition@0x00000000 {
				label =3D "fpga";
				reg =3D <0x00000000 0x00b00000>;
			};
			partition@0x00b00000 {
				label =3D "boot";
				reg =3D <0x00b00000 0x00040000>;
			};
			partition@0x00b40000 {
				label =3D "bootenv";
				reg =3D <0x00b40000 0x00020000>;
			};
			partition@0x00b60000 {
				label =3D "image";
				reg =3D <0x00b60000 0x00c00000>;
			};
			partition@0x01760000 {
				label =3D "spare";
				reg =3D <0x01760000 0x00000000>;
			};
		} ;
		push_buttons_5bits: gpio@40030000 {
			#gpio-cells =3D <2>;
			compatible =3D "xlnx,axi-gpio-2.0", "xlnx,xps-gpio-1.00.a";
			gpio-controller ;
			reg =3D <0x40030000 0x10000>;
			xlnx,all-inputs =3D <0x1>;
			xlnx,all-inputs-2 =3D <0x0>;
			xlnx,all-outputs =3D <0x0>;
			xlnx,all-outputs-2 =3D <0x0>;
			xlnx,dout-default =3D <0x0>;
			xlnx,dout-default-2 =3D <0x0>;
			xlnx,gpio-width =3D <0x5>;
			xlnx,gpio2-width =3D <0x20>;
			xlnx,interrupt-present =3D <0x0>;
			xlnx,is-dual =3D <0x0>;
			xlnx,tri-default =3D <0xffffffff>;
			xlnx,tri-default-2 =3D <0xffffffff>;
		} ;
		reset_gpio: gpio@40000000 {
			#gpio-cells =3D <2>;
			compatible =3D "xlnx,axi-gpio-2.0", "xlnx,xps-gpio-1.00.a";
			gpio-controller ;
			reg =3D <0x40000000 0x10000>;
			xlnx,all-inputs =3D <0x0>;
			xlnx,all-inputs-2 =3D <0x0>;
			xlnx,all-outputs =3D <0x1>;
			xlnx,all-outputs-2 =3D <0x0>;
			xlnx,dout-default =3D <0x0>;
			xlnx,dout-default-2 =3D <0x0>;
			xlnx,gpio-width =3D <0x1>;
			xlnx,gpio2-width =3D <0x20>;
			xlnx,interrupt-present =3D <0x0>;
			xlnx,is-dual =3D <0x0>;
			xlnx,tri-default =3D <0xffffffff>;
			xlnx,tri-default-2 =3D <0xffffffff>;
		} ;
		rs232_uart: serial@40400000 {
			clock-frequency =3D <100000000>;
			compatible =3D "xlnx,axi-uart16550-2.0", "xlnx,xps-uart16550-2.00.a", =
"ns16550a";
			current-speed =3D <115200>;
			device_type =3D "serial";
			interrupt-parent =3D <&microblaze_0_axi_intc>;
			interrupts =3D <4 2>;
			reg =3D <0x40400000 0x2000>;
			reg-offset =3D <0x1000>;
			reg-shift =3D <2>;
			xlnx,external-xin-clk-hz =3D <0x17d7840>;
			xlnx,external-xin-clk-hz-d =3D <0x19>;
			xlnx,has-external-rclk =3D <0x0>;
			xlnx,has-external-xin =3D <0x0>;
			xlnx,is-a-16550 =3D <0x1>;
			xlnx,s-axi-aclk-freq-hz-d =3D <0x64>;
			xlnx,use-modem-ports =3D <0x1>;
			xlnx,use-user-ports =3D <0x1>;
		} ;
	} ;
} ;

--------------040208070306000709060500--

--A0miHcxEWMCXSruAF402wMfnfKlSLUv4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM+sgcACgkQykllyylKDCGIqACeLS0InY6aMfDw86rahHLjjyob
W0cAn2RLTz4oxNFSq3kWQfT5x6wykTZu
=ldfa
-----END PGP SIGNATURE-----

--A0miHcxEWMCXSruAF402wMfnfKlSLUv4S--
