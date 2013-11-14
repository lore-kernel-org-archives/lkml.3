Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab3KNVQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 16:16:33 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:46330 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab3KNVQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 16:16:25 -0500
MIME-Version: 1.0
In-Reply-To: <20131114201746.GB14807@hmsreliant.think-freely.org>
References: <20131029214631.GA19354@kroah.com> <CAErSpo5YpE-aoTbXd5=0xBDe+_aQPEO4PejrG=+JoEM=w2ZxQw@mail.gmail.com>
 <20131102155054.GD23938@kroah.com> <CAErSpo5DD_H8_auWZ9QAVPLk85=Zcviv3RjeEWmHQkHPnFPCzA@mail.gmail.com>
 <CAErSpo6Q3LvDN0QkOf4HnsDZf7neNgSE2nz2Z191Ajp62OLVrQ@mail.gmail.com> <20131114201746.GB14807@hmsreliant.think-freely.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 14 Nov 2013 14:16:04 -0700
Message-ID: <CAErSpo6jmoRyy58WUijG_HeBYbTBa5mFpn8=d=sMBp51X4ZFqg@mail.gmail.com>
Subject: Re: [RFC PATCH] PCI: export MSI mode using attributes, not kobjects
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Veaceslav Falico <vfalico@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 1:17 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Thu, Nov 14, 2013 at 12:33:11PM -0700, Bjorn Helgaas wrote:
>> On Tue, Nov 5, 2013 at 11:55 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> > On Sat, Nov 2, 2013 at 9:50 AM, Greg Kroah-Hartman
>> > <gregkh@linuxfoundation.org> wrote:
>> >> On Fri, Nov 01, 2013 at 05:40:02PM -0600, Bjorn Helgaas wrote:
>> >>> On Tue, Oct 29, 2013 at 3:46 PM, Greg Kroah-Hartman
>> >>> <gregkh@linuxfoundation.org> wrote:
>> >>> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> >>> >
>> >>> > The PCI MSI sysfs code is a mess with kobjects for things that don't
>> >>> > really need to be kobjects.  This patch creates attributes dynamically
>> >>> > for the MSI interrupts instead of using kobjects.
>> >>> >
>> >>> > Note, this does not delete the existing sysfs MSI code, but puts the
>> >>> > attributes under a "msi_irqs_2" directory for testing / example.
>> >>> >
>> >>> > Also note, this removes a directory from the current MSI interrupt sysfs
>> >>> > code:
>> >>> >
>> >>> > old MSI kobjects:
>> >>> > pci_device
>> >>> >    └── msi_irqs
>> >>> >        └── 40
>> >>> >            └── mode
>> >>> >
>> >>> > new MSI attributes:
>> >>> > pci_device
>> >>> >    └── msi_irqs_2
>> >>> >        └── 40
>> >>> >
>> >>> > As there was only one file "mode" with the kobject model, the interrupt
>> >>> > number is now a file that returns the "mode" of the interrupt (msi vs.
>> >>> > msix).
>> >>> >
>> >>> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> >>> > ---
>> >>> >
>> >>> > Bjorn, I can make up a patch that rips out the existing kobject code
>> >>> > here, but I figured this patch would make things easier to follow
>> >>> > instead of having to dig through the removed logic at the same time.
>> >>> >
>> >>> > I'll clean up the error handling path for the create attribute logic as
>> >>> > well, this was just a proof of concept that this could be done.
>> >>> >
>> >>> > Do you think that anyone cares about the current mode files in sysfs to
>> >>> > move things in this manner?
>> >>>
>> >>> I like this a lot better than trying to fix all the holes in the
>> >>> current kobject code.
>> >>
>> >> Great.
>> >>
>> >>> I have no idea who, if anybody, cares about the "mode" files.  I
>> >>> assume there's a way to create the "mode" files with attributes, too?
>> >>> If so, we could replicate the existing structure with one patch, and
>> >>> simplify it with a second patch, so it would be easier to revert the
>> >>> directory change while keeping the fix.
>> >>
>> >> No, we can't create a 2-level deep attribute at the moment, only one
>> >> level, like the patch does.
>> >>
>> >> Based on Neil's comments, I think we should be fine with this as-is as
>> >> no one is messing with these files directly (which implies that we could
>> >> possibly just remove them entirely to save us the overall pain...)
>> >
>> > Hmmm.  https://bugzilla.redhat.com/show_bug.cgi?id=744012 suggests
>> > that irqbalance might be reading these files.
>>
>> I looked at the current irqbalance on github [1], and I *think* it
>> never reads the "mode" files.  It reads the entries in the "msi_irqs"
>> directory, which you're proposing to change from directories to files,
>> but I think it only uses the names.
>>
> It doesn't read the mode file (I had intended for it to, but all the information
> irqbalance needs currently is implied by the fact that it appears in the sysfs
> tree under msi_irqs in the first place).
>
>> It looks like it should be safe at least for irqbalance to make this a
>> one-level attribute.  It's possible we'll break somebody's scripts,
>> but I'm willing to try making this change because it really makes the
>> refcounting much simpler.
>>
> ACK, if you cc me on the patch that will change the sysfs directory structure,
> I'll make the corresponding changes needed to irqblanace in parallel.

I'm hoping *no* changes will be required to irqbalance.  All it seems
to care about are the names of the entries inside "msi_irqs".  The
names will stay the same; they'll just change from being directories
to being files.

If an irqbalance change *is* required, then I'm much more hesitant.  I
don't want to force people to install a new irqbalance along with a
new kernel.

Bjorn
