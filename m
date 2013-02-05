Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3BENb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:31:58 -0500
Received: from meriadoc.sigma-star.at ([178.63.61.2]:36726 "EHLO
	meriadoc.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab3BENb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:31:56 -0500
Message-ID: <1360071110.6200.19.camel@riven-lux.site>
Subject: Re: DMAR faults from unrelated device when vfio is used
From: David Gstir <david@sigma-star.at>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, richard@sigma-star.at
Date: Tue, 05 Feb 2013 14:31:50 +0100
In-Reply-To: <1359992968.11144.414.camel@bling.home>
References: <1359972630.2498.21.camel@riven-lux.site>
	 <1359992968.11144.414.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 04.02.2013, 08:49 -0700 schrieb Alex Williamson:

> Can you clarify what you mean by assign?  Are you actually assigning the
> root ports to the qemu guest (1c.0 & 1c.6)?  vfio will require they be
> owned by vfio-pci to make use of 3:00.0, but assigning them to the guest
> is not recommended.  Can you provided your qemu command line?  

I did hand all of them to the guest OS. Removing 1c.0 & 1c.6 from the qemu 
command line seems to have done the trick. Thanks!

Here's my working qemu command line:
qemu-kvm -no-reboot -enable-kvm -cpu host -smp 4 -m 6G \
  -drive file=/home/test/qemu/images/win7_base_updated.qcow2,if=virtio,cache=none,media=disk,format=qcow2,index=0 \
  -full-screen -no-quit -no-frame -display sdl -vnc :1 -k de -usbdevice tablet \
  -vga std -global VGA.vgamem_mb=256 \
  -netdev tap,id=guest0,ifname=tap0,script=no,downscript=no \
  -net nic,netdev=guest0,model=virtio,macaddr=00:16:35:BE:EF:12  \
  -rtc base=localtime \
  -device vfio-pci,host=00:1b.0,id=audio \
  -device vfio-pci,host=00:1a.0,id=ehci1 \
  -device vfio-pci,host=00:1d.0,id=ehci2 \
  -device vfio-pci,host=03:00.0,id=xhci1 \
  -monitor tcp::5555,server,nowait


> We need
> to re-visit how to handle pcieport devices with vfio-pci, perhaps
> white-listing it as a vfio "compatible" driver, but this still should
> not interfere with devices external to the group.
> 
> The DMAR fault address looks pretty bogus unless you happen to have
> 100GB+ of ram in the system.

Nope, definitely not. :)

> vfio makes use of the IOMMU API for programming DMA translations, so an
> reserved fields would have to be programmed by intel-iommu itself.  We
> could of course be passing some kind of bogus data that intel-iommu
> isn't catching.  If you're assigning the root ports to the guest, I'd
> start with that, don't do it.  Attach them to vfio, but don't give them
> to the guest.  Maybe that'll give us a hint.  I also notice that your
> USB 3 controller is dead:
> 
> 03:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev ff) (prog-if ff)
> 	!!! Unknown header type 7f
> 
> We only see unknown header type 7f when the read from the device returns
> -1.  This might have something to do with the root port above it (1c.6)
> being in state D3.  Windows likes to put unused devices in D3, which
> leads me to suspect you are giving it to the guest.  

There error does no longer occur. lspci now shows this:

-- snip --
03:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04) (prog-if 30 [XHCI])
	Subsystem: Intel Corporation Device 2008
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fe500000 (64-bit, non-prefetchable) [disabled] [size=8K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D3 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] MSI: Enable- Count=1/8 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [90] MSI-X: Enable- Count=8 Masked-
		Vector table: BAR=0 offset=00001000
		PBA: BAR=0 offset=00001080
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 unlimited
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number ff-ff-ff-ff-ff-ff-ff-ff
	Capabilities: [150 v1] Latency Tolerance Reporting
		Max snoop latency: 0ns
		Max no snoop latency: 0ns
	Kernel driver in use: vfio-pci
-- snip --

Most likely because I don't hand the root ports over to the guest anymore. 
However, there seems to be another issue with the USB 3 controller since 
windows 7 can't start the device (error 10 in windows device manager). Using 
these USB ports in the host linux worked fine. Could this issue be related to 
pci-express?

Thanks,
David




