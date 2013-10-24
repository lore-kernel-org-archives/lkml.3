Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3JXFuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 01:50:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35176 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3JXFue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 01:50:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, jerry.hoemann@hp.com,
        hpa@linux.intel.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        fengguang.wu@intel.com, jingbai.ma@hp.com
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
	<20131022220803.GA32387@anatevka.fc.hp.com>
	<526712B2.7070108@jp.fujitsu.com> <20131023155127.GA17437@redhat.com>
Date: Wed, 23 Oct 2013 22:50:13 -0700
In-Reply-To: <20131023155127.GA17437@redhat.com> (Vivek Goyal's message of
	"Wed, 23 Oct 2013 11:51:27 -0400")
Message-ID: <871u3bcj56.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/hs4na26NybbUtQ7SISh83hJ9vfjANFxU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0387]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel parameter
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Hi Hatayama,
>
> So what information should I look for to prepare disable_cpu_apic=X in
> kdump script?
>
> Is BSP processor info exported to user space somewhere? Or assuming that
> processor 0 is BSP and corresponding apicid should be disabled in kdump
> kernel is good enough?

On x86 assuming that processor 0 is BSP should be good enough.  Unless
we starting getting SMP BIOSen playing games with us.

> I am looking at /proc/cpuinfo and following 3 fields seem interesting.
>
> processor: 0
> apicid		: 0
> initial apicid	: 0
>
> What's the difference between apicid and "initial apicid". I guess
> initial apicid reflects the apicid number as set by firmware and then
> kernel can overwrite it and new number would be reflected in "apicid"?

Last I was current initial apicid is the apic id the hardware chooses
and it tells you something about the topology of the processors in the
system.

The apicid is programmed by the BIOS so that the BSP can have apicid 0,
and apicid's can be contiguous etc.  In principle any piece of software
can program apicids but there is no advantage.

> If that's the case, then I guess we should be looking at "apicid" of
> processor "0" and set that in disable_cpu_apic? Because that's the
> number kdump kernel  boot should see in apic upon boot.

Restricting this to x86 and not Voyager that is correct.  Linux cpu 0
is the processor we booted up on as is apparent lots of things special
case the bootstrap processor so using a cpu hotplug remove to make it go
away is silly.  Still to handle cazy cpu hotplug I would recomend to
simply force a single cpu if you can't find cpu 0.

Eric

