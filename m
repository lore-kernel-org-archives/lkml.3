Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaJBJSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 05:18:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51941 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaJBJSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:18:07 -0400
Date: Thu, 2 Oct 2014 11:18:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Tejun Heo <tj@kernel.org>, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, tiwai@suse.de,
        arjan@linux.intel.com, teg@jklm.no, rmilasan@suse.com, werner@suse.com,
        oleg@redhat.com, hare@suse.com, bpoirier@suse.de, santosh@chelsio.com,
        pmladek@suse.cz, dbueso@suse.com, linux-kernel@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH v1 3/5] amd64_edac: enforce synchronous probe
Message-ID: <20141002091800.GA31189@pd.tnic>
References: <1411768637-6809-1-git-send-email-mcgrof@do-not-panic.com>
 <1411768637-6809-4-git-send-email-mcgrof@do-not-panic.com>
 <20140928144123.GB5023@mtj.dyndns.org>
 <20140930072328.GD14081@wotan.suse.de>
 <20141001223959.GN14081@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141001223959.GN14081@wotan.suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 12:39:59AM +0200, Luis R. Rodriguez wrote:
> ...
> and my system was still useless and even end up in some fun page faults,
> but again I think this is all related. I reviewed sysfs / kernfs code
> and didn't see issues there with how symlinks are handled so I started
> reviewing the driver itself a bit and saw it had strong use of sysfs
> on itself and also on helpers such as edac_create_sysfs_mci_device().
> I would not be surprised if the issue lies more in there than elsewhere.

Right, but that would point at sysfs being not asyns-ready, right? I
mean, the driver is just a user of sysfs and doesn't do anything out of
the ordinary in that respect. And the sysfs usage comes from the EDAC
core so I think you'll basically end up marking *all* EDAC drivers as
sync because they all call edac_create_sysfs_mci_device() - you just
happened to run an AMD box and see it there.

This might turn fast into a nasty game if other drivers do similar things
so I'd say this needs to get properly debugged to see what is causing it
and fixed there. And my money goes on that

	WARNING: CPU: 2 PID: 127 at fs/kernfs/dir.c:377 kernfs_get+0x31/0x40()

which is there for some reason and apparently shouldn't be happening...

Just an IMHO of course.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
