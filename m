Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3IWWBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:01:55 -0400
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:61060 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752503Ab3IWWBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:01:53 -0400
X-TM-IMSS-Message-ID: <2e41643100026179@nsa.gov>
Message-ID: <5240BA0E.3000304@tycho.nsa.gov>
Date: Mon, 23 Sep 2013 18:00:46 -0400
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: tpmdd-devel@lists.sourceforge.net,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [tpmdd-devel] [PATCH 09/13] tpm: Pull everything related to sysfs
 into tpm-sysfs.c
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com> <1379960083-8942-10-git-send-email-jgunthorpe@obsidianresearch.com> <52408E5D.4020904@tycho.nsa.gov> <20130923193633.GA9194@obsidianresearch.com> <5240A2A3.4040102@tycho.nsa.gov> <20130923204232.GB16345@obsidianresearch.com>
In-Reply-To: <20130923204232.GB16345@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 04:42 PM, Jason Gunthorpe wrote:
> On Mon, Sep 23, 2013 at 04:20:51PM -0400, Daniel De Graaf wrote:
>
>> That's fine; it wasn't really advertised in the description, and was
>> mostly added in order to demonstrate the locality security label binding
>> in Xen's vtpm-stubdom.
>
> Ok, lets take it out for now then? I'll send a patch.
>
>>> It looks like this driver was introduced in the 3.12 merge window, we
>>> could drop the attribute, and try to merge a core supported locality
>>> API in 3.13? What do you think?
>>>
>>> But, if you say it is needed, it is easy enough to adjust this patch
>>> series.
>
>> If it's replaced with an alternative, I don't think the sysfs attribute
>> will need to remain.  I am not aware of any clients that currently use
>> this attribute.  The sysfs attribute could remain as the common interface
>> for changing locality, unless you think an ioctl on /dev/tpm0 or
>> something else would be preferable (the attribute was just the simplest
>> way to implement locality switching at the time).
>
> Off the very top of my head:
>
> I suspect that a good API would be a sysfs attribute
> 'default_locality' and an IOCTL to change localities.  The
> default_locality would only take effect when the /dev/tpmX is opened,
> so fiddling with sysfs doesn't break active users.
>
> The struct ops I've added would have a function to change localities,
> some of the generic TPM functions should be revised to have a locality
> argument.
>
> Some thought is needed to determine what locality in-kernel users
> should be using. I suspect userspace and kernel space should not be
> forced to the same locality.
>
> Should user space be restricted to a subset of localities?

In a PC client TPM, normal OS code (as opposed to firmware or microcode)
is already restricted to locality 0-2. It may make sense to restrict
locality 2 to the kernel, which would allow an in-kernel TPM seal
command to be able to bind data so that userspace cannot unseal it.
However, only allowing localities 0 and 1 to userspace may be too
restrictive if userspace also wishes to use locality for separation,
since locality 1 does not have the ability to reset any PCRs that
locality 0 cannot also reset.
         
The kernel could reserve only locality 1 for its own use, giving it the
ability to seal data but not interfering with the ability to reset PCRs.
This would be my preference, although it is less intuitive to allow code
of lower privilege (userspace) to control the higher numbered locality
2.

Perhaps a .config option would be useful to allow the system designer to
choose what, if any, locality to reserve for kernel use?

> What use models do you see with the security label binding mechanism
> you have on the hypervisor side?
>
> Jason
>

Currently, Xen's virtual TPM restricts certain localities to certain
domains as identified by the domain's security label. For example, a
guest VM may only be allowed to use locality 0-2 (as on real hardware),
while the device model domain associated with the guest is allowed
locality 0-4, and a monitoring/introspection domain must use another
vTPM-only locality (perhaps 5; the TCG can define additional localities
for use in vTPMs).

-- 
Daniel De Graaf
National Security Agency
