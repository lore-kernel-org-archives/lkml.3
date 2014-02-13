Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaBMCsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 21:48:09 -0500
Received: from mail.wdtv.com ([66.118.69.84]:47299 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbaBMCsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 21:48:07 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: i386_defconfig for 3.13.2?
Date: Wed, 12 Feb 2014 21:48:04 -0500
Cc: linux-kernel@vger.kernel.org
References: <201402121408.12535.gheskett@wdtv.com> <52FC2531.9000304@infradead.org>
In-Reply-To: <52FC2531.9000304@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201402122148.04608.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 February 2014, Randy Dunlap wrote:
>On 02/12/2014 11:08 AM, Gene Heskett wrote:
>> Greetings, not making any progress on newer kernel builds yet.
>> 
>> So I unpacked 3.13.2 this morning and copied its
>> arch/x86/i386_defconfig to .config.
>> 
>> Ran make oldconfig, then 3 or 4 sessions of xconfig removing stuff that
>> isn't for my hardware & generally making lots of modules where I wasn't
>> sure.
>> 
>> But, my "makeit" script, when it makes the initrd, spits out this, and
>> note the not always final "/"
>> 
>> now making a new /boot/initrd.3.13.2.img
>> find: `/lib/modules/3.13.2/kernel/arch': No such file or directory
>> find: `/lib/modules/3.13.2/kernel/arch': No such file or directory
>> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
>> 
>> And indeed that directory does not exist.
>> And that string does not exist in the .config.
>> 
>> Does this ring any bells?
>
>Not for me, but building the initrd (or initramfs) may be
>distro-specific. You might have to share the command that was used for
>that and maybe even the script that was executed (like /sbin/mkinitrd --
>where yours and mine are probably different depending on distros).
>
>Have you (your script) already run 'make install' at this point?
>AFAIK, that should have created /lib/modules/3.13.2/kernel/arch/ and some
>other subdirectories there.

Good Q, lemme look at makeit..  Apparently not.  My script keeps a 2nd copy 
of everything so all I have to do to revert if the previous version worked 
is rm the $VER and mv the $VER.old back to $VER.
=========================makeit==================
#!/bin/sh
## this script assumes you have downloaded, unpacked kernel-
whatever.version
## First, edit this to set the version string to match the Makefile setting
# yeah, I know, I should pass it as $1.  Someday...
VER=3.13.2
LOC=`pwd`
echo now making kernel $VER, if not right, hit ctl+c now && \
sleep 5 && \
echo && \
make clean && \
make prepare && \
echo && \
echo && \
echo making bzImage && \
echo && \
echo && \
ccache make CONFIG_DEBUG_SECTION_MISMATCH=y -j3 bzImage && \
echo && \
echo && \
echo Now making modules && \

echo && \
echo && \ccache make CONFIG_DEBUG_SECTION_MISMATCH=y -j3 modules && \
echo && \
echo && \
echo doing a make headers_install && \
echo && \
echo && \
make headers_install && \
echo && \
echo && \
echo removing /boot/vmlinuz-$VER.old && \
echo && \
echo && \
touch /boot/vmlinuz-$VER.old && \
rm -f /boot/vmlinuz-$VER-old && \
echo && \
echo && \
echo touching vmlinuz-$VER && \
touch /boot/vmlinuz-$VER && \
echo && \
echo && \
echo mv-ing /boot/vmlinuz-$VER /boot/vmlinuz-$VER.old && \
mv -f /boot/vmlinuz-$VER /boot/vmlinuz-$VER.old && \
echo && \
echo copying bzImage to /boot/vmlinuz-$VER && \
cp -f arch/x86/boot/bzImage /boot/vmlinuz-$VER && \
echo removing old lib/modules/$VER.old && \
rm -fR /lib/modules/$VER.old && \
echo touching /lib/modules/$VER && \
touch /lib/modules/$VER && \
echo moving /lib/modules/$VER to /lib/modules/$VER.old && \
mv -f /lib/modules/$VER /lib/modules/$VER.old && \
echo cleaning up in /boot && \
rm -f /boot/System.map && \
echo saving the System.map-$VER to System.map-$VER.old && \
touch /boot/System.map-$VER && \
mv /boot/System.map-$VER /boot/System.map-$VER.old && \
echo copying in new System.map && \
cp -f System.map /boot/System.map-$VER && \
echo cd-ing to /boot && \
cd /boot && \
echo doing the link of System.map-$VER to System.map && \
ln -s System.map-$VER System.map && \
echo cd-ing back to $LOC to do the modules_install && \
cd $LOC && \
echo && \
pwd && \
echo make modules_install && \
ccache make -j3 modules_install && \
echo installing firmware && \
make firmware_install && \
echo now making a new /boot/initrd.$VER.img && \
# touch it in case its not there yet && \
touch /boot/initrd-$VER.img && \
# then move it to .old && \
mv /boot/initrd-$VER.img /boot/initrd-$VER.old && \
# now make a new one IN /boot! && \
mkinitramfs -o/boot/initrd-$VER.img $VER && \
echo and copying it to initrd-$VER.img && \
touch initrd-$VER.img.old && \
rm -f initrd-$VER.img.old && \
# leave a copy here too && \
cp /boot/initrd-$VER.img initrd-$VER.img && \
cd $LOC && \
depmod -a -e -F System.map $VER && \
# Ok, now we need to be saving the .config in /boot and dump the copy in 
/proc \
touch /boot/config-$VER.gz && \
mv /boot/config-$VER.gz /boot/config-$VER.gz.old && \
gzip -c .config >/boot/config-$VER.gz && \
ls -l /boot/ | grep config-$VER.gz && \
echo && \
echo "All done making "$VER"! Edit grub.conf, reboot and chose your kernel 
at the grub prompt"


===================EOF================
I can replace the bZimage copy with a make install, but that would appear 
to need an order re-arrangement.  What can be excised, or moved up and 
where should the make install line go?

I don't want to lose the .old copies, they have been handy in the past.  
Although it does complicate the update-grub since they should up in the 
grub menu too.  Since we have much larger /boot partitions than were  
allowed when I first carved the great great grandparent of this script a 
decade ago, maybe it is time the .old gingerbread did leave.  There is now 
lots of room in /boot for attempts that fail.

That means I probably could:
1. ccache make CONFIG_DEBUG_SECTION_MISMATCH=y -j3 bzImage && \
2. ccache make CONFIG_DEBUG_SECTION_MISMATCH=y -j3 modules && \
3. make install (new)
4. make modules_install && \ (or is this even needed now?)
5. mkinitramfs -o/boot/initrd-$VER.img $VER && \
6 and do the .config saving
7 update-grub
If that is the now correct order, I can do that easy enough.

Sometimes you have to head this old electron cowboy off at the pass.

Thanks Randy.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

