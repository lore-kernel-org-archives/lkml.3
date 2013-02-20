Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935508Ab3BTNjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:39:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935316Ab3BTNja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:39:30 -0500
Date: Wed, 20 Feb 2013 08:39:24 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org,
        lxiang@redhat.com, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 10/15] acpi: Ignore acpi_rsdp kernel parameter in a
 secure boot environment
Message-ID: <20130220133924.GF362@hansolo.jdub.homelinux.org>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
 <1359391359-25783-11-git-send-email-matthew.garrett@nebula.com>
 <CABqxG0cJGp7UEREvMW49QA0BfDXPsyEbAuMMLZwcHPdUAKT+Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABqxG0cJGp7UEREvMW49QA0BfDXPsyEbAuMMLZwcHPdUAKT+Dw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 05:00:23PM +0800, Dave Young wrote:
> On Tue, Jan 29, 2013 at 12:42 AM, Matthew Garrett
> <matthew.garrett@nebula.com> wrote:
> > From: Josh Boyer <jwboyer@redhat.com>
> >
> > This option allows userspace to pass the RSDP address to the kernel.  This
> > could potentially be used to circumvent the secure boot trust model.
> > We ignore the setting if we don't have the CAP_COMPROMISE_KERNEL capability.
> >
> > Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> > ---
> >  drivers/acpi/osl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> > index bd22f86..88251d2 100644
> > --- a/drivers/acpi/osl.c
> > +++ b/drivers/acpi/osl.c
> > @@ -246,7 +246,7 @@ early_param("acpi_rsdp", setup_acpi_rsdp);
> >  acpi_physical_address __init acpi_os_get_root_pointer(void)
> >  {
> >  #ifdef CONFIG_KEXEC
> > -       if (acpi_rsdp)
> > +       if (acpi_rsdp && capable(CAP_COMPROMISE_KERNEL))
> 
> 
> This caused an issue in a kdump test even without secure boot enabled.
> Looks like security subsystem init is not initialized yet at this
> point.
> 
> See redhat bug 906225:
> https://bugzilla.redhat.com/show_bug.cgi?id=906225

I've fixed this in a newer revision of the patch.  Basically we can't
rely on capable() working at this point because security_init hasn't
been called yet.  Sigh.

Despite the desire to not sprinkle if (!secure_boot) checks all over,
I'm thinking less and less that using a CAP is going to work.  Maybe
I'll come up with some kind of secure_kernel() function that can be set
per-arch or something and use that instead.  At least that would have
the semantics we're looking for without breaking in various places or
causing unintended side-effects in userspace.

josh
