Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804Ab3BYXfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:35:43 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:64063 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759567Ab3BYXfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:35:40 -0500
MIME-Version: 1.0
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA92869CE90@sacexcmbx05-prd.hq.netapp.com>
References: <512606DF.5050706@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
 <512635D2.4090207@redhat.com> <51267CEB.8070805@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
 <20130221222449.GY22221@lenny.home.zabbo.net> <512BD44C.40907@amacapital.net>
 <512BDC82.5060203@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA928699C17@sacexcmbx05-prd.hq.netapp.com>
 <CALCETrVXxdJ0Pg7wLS9T7mHRj8Ak2M1Yn3EPE_eBmHN3L9+70A@mail.gmail.com> <4FA345DA4F4AE44899BD2B03EEEC2FA92869CE90@sacexcmbx05-prd.hq.netapp.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 25 Feb 2013 15:35:18 -0800
Message-ID: <CALCETrU-cfYeEnh6DF4f6z=d0gJsPd1rfShbPDYF4kX8R+8eRQ@mail.gmail.com>
Subject: Re: New copyfile system call - discuss before LSF?
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Zach Brown <zab@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 3:28 PM, Myklebust, Trond
<Trond.Myklebust@netapp.com> wrote:
> On Mon, 2013-02-25 at 14:16 -0800, Andy Lutomirski wrote:
>> On Mon, Feb 25, 2013 at 1:59 PM, Myklebust, Trond
>> <Trond.Myklebust@netapp.com> wrote:
>> > On Mon, 2013-02-25 at 16:49 -0500, Ric Wheeler wrote:
>> >> On 02/25/2013 04:14 PM, Andy Lutomirski wrote:
>> >> > On 02/21/2013 02:24 PM, Zach Brown wrote:
>> >> >> On Thu, Feb 21, 2013 at 08:50:27PM +0000, Myklebust, Trond wrote:
>> >> >>> On Thu, 2013-02-21 at 21:00 +0100, Paolo Bonzini wrote:
>> >> >>>> Il 21/02/2013 15:57, Ric Wheeler ha scritto:
>> >> >>>>>> sendfile64() pretty much already has the right arguments for a
>> >> >>>>>> "copyfile", however it would be nice to add a 'flags' parameter: the
>> >> >>>>>> NFSv4.2 version would use that to specify whether or not to copy file
>> >> >>>>>> metadata.
>> >> >>>>> That would seem to be enough to me and has the advantage that it is an
>> >> >>>>> relatively obvious extension to something that is at least not totally
>> >> >>>>> unknown to developers.
>> >> >>>>>
>> >> >>>>> Do we need more than that for non-NFS paths I wonder? What does reflink
>> >> >>>>> need or the SCSI mechanism?
>> >> >>>> For virt we would like to be able to specify arbitrary block ranges.
>> >> >>>> Copying an entire file helps some copy operations like storage
>> >> >>>> migration.  However, it is not enough to convert the guest's offloaded
>> >> >>>> copies to host-side offloaded copies.
>> >> >>> So how would a system call based on sendfile64() plus my flag parameter
>> >> >>> prevent an underlying implementation from meeting your criterion?
>> >> >> If I'm guessing correctly, sendfile64()+flags would be annoying because
>> >> >> it's missing an out_fd_offset.  The host will want to offload the
>> >> >> guest's copies by calling sendfile on block ranges of a guest disk image
>> >> >> file that correspond to the mappings of the in and out files in the
>> >> >> guest.
>> >> >>
>> >> >> You could make it work with some locking and out_fd seeking to set the
>> >> >> write offset before calling sendfile64()+flags, but ugh.
>> >> >>
>> >> >>   ssize_t sendfile(int out_fd, int in_fd, off_t in_offset, off_t
>> >> >>                    out_offset, size_t count, int flags);
>> >> >>
>> >> >> That seems closer.
>> >> >>
>> >> >> We might also want to pre-emptively offer iovs instead of offsets,
>> >> >> because that's the very first thing that's going to be requested after
>> >> >> people prototype having to iterate calling sendfile() for each
>> >> >> contiguous copy region.
>> >> > I thought the first thing people would ask for is to atomically create a
>> >> > new file and copy the old file into it (at least on local file systems).
>> >> >   The idea is that nothing should see an empty destination file, either
>> >> > by race or by crash.  (This feature would perhaps be described as a
>> >> > pony, but it should be implementable.)
>> >> >
>> >> > This would be like a better link(2).
>> >> >
>> >> > --Andy
>> >>
>> >> Why would this need to be atomic? That would seem to be a very difficult
>> >> property to provide across all target types with multi-GB sized files...
>> >
>> > Right. It may sound cool, but what's the real-life use case?
>> >
>>
>> Download file from some source and then verify it.  Now copyfile it
>> into my repository of known-good files.
>>
>> Admittedly I could link + unlink or rename it there, but I consider
>> hard links to be rather evil, especially when cow links are available.
>
> Rename is the right way to do that as it can't corrupt the data after
> you have verified it. copyfile can...

...copyfile doesn't exist.  I think it would be neat if it couldn't
corrupt data.

In any case, this may be a bad idea -- presumably you'd have to fsync
the file you're copying *from* first to avoid a massive performance
hit.

--Andy
