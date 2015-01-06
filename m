Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbbAFMGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:06:22 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55204 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbbAFMGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:06:21 -0500
Message-ID: <54ABCE85.6070004@redhat.com>
Date: Tue, 06 Jan 2015 13:01:09 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
Newsgroups: gmane.comp.emulators.xen.devel,gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Marcelo Tosatti <mtosatti@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>
CC: Gleb Natapov <gleb@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [RFC 2/2] x86, vdso, pvclock: Simplify and speed up the vdso
 pvclock reader
References: <cover.1419295081.git.luto@amacapital.net>	<8d09c16eb39cbe264417cc66c4aca730af10b70b.1419295081.git.luto@amacapital.net>	<20150105152511.GA9172@amt.cnet>	<CALCETrXRs4NmhMvp+7kydrfyGCiNymkTe_sP6HFVvhMCC2Ei0Q@mail.gmail.com>	<20150105191756.GA31201@amt.cnet>	<CALCETrVWmbcv1w5a3N1VzyWEobP0qW+RQkhWO9yOkxzdKdJgeg@mail.gmail.com>	<20150105224858.GA6846@amt.cnet> <54AB9FFD.6070309@redhat.com>
In-Reply-To: <54AB9FFD.6070309@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/01/2015 09:42, Paolo Bonzini wrote:
> > > Still confused.  So we can freeze all vCPUs in the host, then update
> > > pvti 1, then resume vCPU 1, then update pvti 0?  In that case, we have
> > > a problem, because vCPU 1 can observe pvti 0 mid-update, and KVM
> > > doesn't increment the version pre-update, and we can return completely
> > > bogus results.
> > Yes.
> But then the getcpu test would fail (1->0).  Even if you have an ABA
> situation (1->0->1), it's okay because the pvti that is fetched is the
> one returned by the first getcpu.

... this case of partial update of pvti, which is caught by the version
field, if of course different from the other (extremely unlikely) that
Andy pointed out.  That is when the getcpus are done on the same vCPU,
but the rdtsc is another.

That one can be fixed by rdtscp, like

do {
    // get a consistent (pvti, v, tsc) tuple
    do {
        cpu = get_cpu();
        pvti = get_pvti(cpu);
        v = pvti->version & ~1;
        // also acts as rmb();
        rdtsc_barrier();
        tsc = rdtscp(&cpu1);
        // control dependency, no need for rdtsc_barrier?
    } while(cpu != cpu1);

    // ... compute nanoseconds from pvti and tsc ...
    rmb();
}   while(v != pvti->version);
