Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554Ab3DBNay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:30:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760801Ab3DBNax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:30:53 -0400
Date: Tue, 2 Apr 2013 09:30:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] kexec: use Crash kernel for Crash kernel low
Message-ID: <20130402133019.GB29506@redhat.com>
References: <20130320163131.GE2273@redhat.com>
 <1363807329-24975-1-git-send-email-yinghai@kernel.org>
 <20130325194245.GA7357@redhat.com>
 <CAE9FiQU6bGSAODX_-Vir6D-LyY-9Sm84rYzq=gNhDZ5whbia_w@mail.gmail.com>
 <20130326181418.GA6775@redhat.com>
 <20130401133428.GA13499@redhat.com>
 <5159D2E9.7080707@zytor.com>
 <20130401192606.GA17951@redhat.com>
 <5159F27E.7060300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5159F27E.7060300@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 01:47:58PM -0700, H. Peter Anvin wrote:

[..]
> > All this will only address the issue of where to reserve memory. It will
> > still not solve the issue of how much memory to reserve. We have no way
> > to know. It is all heuristics.
> 
> At least heuristics in a script is better than telling the user "guess
> and pray".

Current heuristics are outside the kernel. That is we run tests on bunch
of machines and try to figure out what's a reasonable default amount of
reserved memory (with our kernel and with our initramfs and default
settings).

So we carry a patch in kernel which supports crashkernel=auto option.
Installer puts this option on boot loader command line during installation.

And in kernel we have hardcoded the per arch memory reservation requirements
and we update these limits if something significant changes either in
kernel or in user space in terms of memory consumption.

Initially we had tried to guess second kernel's memory usage based on
first kernel's memory usage, but that did not work. There were many
factors.

- First kernel brought up all the cpus and that inreases the memory
  consumption. While we bring up only one cpu (with nr_cpus=1) in
  kdump kernel.

- We disable memory cgroup controller while first kernel has it enabled
  and that can change memory requirement significantly on large machines.

- We don't bring up all the devices in second kernel while we do in
  first kernel. So module memory usage can be significantly higher in
  first kernel.

So it has been very tricky to come up with some kind of guidelines in
an automated manner. 

But I am more than willing to look into it if there are more ideas on
how one can go about figuring out how much memory to reserve and where
to reserve.

Thanks
Vivek
