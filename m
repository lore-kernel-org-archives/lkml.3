Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbaGVTkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:40:16 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:56039 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbaGVTkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:40:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+V807cyDdyEzoRzSjYEyhkDntaEkKOx6n=OzUoF31-sA@mail.gmail.com>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
 <1405373897-31671-4-git-send-email-keescook@chromium.org> <20140714222419.GC10393@wotan.suse.de>
 <CAGXu5j+V807cyDdyEzoRzSjYEyhkDntaEkKOx6n=OzUoF31-sA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 22 Jul 2014 12:39:47 -0700
X-Google-Sender-Auth: ITTpckck3PRDZ7TOnUCc0PTfET4
Message-ID: <CAB=NE6WnP-7YCr8DzCq-HOLZVuQxmCa+nwN7kQBxTnUHK+xMRg@mail.gmail.com>
Subject: Re: [PATCH 3/7] security: introduce kernel_fw_from_file hook
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 3:31 PM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Jul 14, 2014 at 3:24 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>> On Mon, Jul 14, 2014 at 02:38:13PM -0700, Kees Cook wrote:
>>> +int security_kernel_fw_from_file(struct file *file, char *buf, size_t size)
>>> +{
>>> +     return security_ops->kernel_fw_from_file(file, buf, size);
>>> +}
>>> +EXPORT_SYMBOL_GPL(security_kernel_fw_from_file);
>>
>> I have a use case in mind already (CRDA) whereby a non-driver but a core part of
>> the kernel would like to use the request_firmware_direct() API and leave
>> it optional to that part of the kernel if or not a digital signature check
>> is required since this is already an optional feature. Since LSM would be
>> used for the digital signatures it it'd be good if we allowed drivers and
>> the kernel to specify whether or not a the LSM signature hook does indeed
>> need to be used.
>>
>> Additionally there may be different signature requirements on the file, one
>> might be willing to *require* a digital signature check even if say dm-verity
>> was used, one use case here is wanting the to require as part of the
>> specification a one to one mapping of file --> signature. That may be a
>> bit paranoid... but its certainly a possibility. This could be addressed by
>> allowing a user to express whether one security mechanism is sufficient
>> for an expected one, or if one is definitely required. One example here
>> could be the ability for a driver / kernel to express that dm-verity would
>> not suffice for a request_firmware_direct() call. I'm not saying that I
>> *know* this use case exists, am just saying I can expect it and do consider
>> it subjective to assume we'd agree on possible security intersections.
>
> The policy of accepting the firmware or not is up to the loaded LSM
> (so it can choose how to either check that the fd is tied to
> dm-verity, or that a signature maps to the right key or key, or if IMA
> thinks the file is unchanged, etc).
>
> And example of LSM policy for kernel modules is my proposed kernel
> module restriction LSM:
> https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=lsm-mod-pin
>
> With fw-restriction in place, I would likely extend this LSM to add a
> check to the fw hook too.

That would be great. I'll go review that code next.

>> I see this also adds a hook for fw itself, meanwhile we already had one for
>> modules. The request_firmware() API is already used on other areas of the
>> kernel for non-firmware files, it can be used to load optional CPU microcode
>> upgrade, EEPROM optional override files, and in the wireless case I'd like to
>> see if we could replace CRDA by using the same APIs / mechanisms as well to
>> avoid having to deal with complexities on parsers with CFG80211_INTERNAL_REGDB.
>> Besides nomenclature fuzz as usage of request_firmware() API grows it occurs to
>> me that perhaps these hooks could be generalized at the kobject granularity
>> level. That should make it easier to scale and consider these LSM hooks for any
>> type of other object in the kernel in the future. kobjects may be overkill
>> though, unless we could enable the option to have have these hooks only
>> optional for certain type of kobjects.
>
> Yup, with this and the module hook, adding a similar hook for kexec
> makes sense as well. A paranoid kernel doesn't want to trust anything
> it's loading from userspace. :)

Well I'm actually wondering if we could generalize requiring hooks or
not for LSM as part of the general kobject definition. Then we
wouldn't need to keep growing hooks for modules, firmware, kexec
images, etc, but instead using the interfaces for kobjects and who
depend on them. How that would actually look -- I'm not sure, but just
a thought.

  Luis
