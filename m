Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3ILNRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:17:07 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46930 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab3ILNRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:17:05 -0400
Date: Thu, 12 Sep 2013 09:16:55 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] firmware: Be a bit more verbose about direct firmware
 loading failure
Message-ID: <20130912131655.GA8619@hmsreliant.think-freely.org>
References: <1378496168-3684-1-git-send-email-nhorman@tuxdriver.com>
 <CACVXFVPRWEXMHyGhfZVGX2HrL3cguqVBUjTS51r2p8EGt=EPdg@mail.gmail.com>
 <20130911141943.GA3181@neilslaptop.think-freely.org>
 <CACVXFVNfkfsSJJUK_BWHLnddk=NAWDJoERmg_qycYa11G_X2RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNfkfsSJJUK_BWHLnddk=NAWDJoERmg_qycYa11G_X2RA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 10:25:58AM +0800, Ming Lei wrote:
> On Wed, Sep 11, 2013 at 10:19 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > On Wed, Sep 11, 2013 at 07:54:28PM +0800, Ming Lei wrote:
> >> On Sat, Sep 7, 2013 at 3:36 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> >> > The direct firmware loading interface is a bit quiet about failures.  Failures
> >>
> >> Because there are several pre-defined search paths, and generally the
> >> requested firmware only exists in one of these paths.
> >>
> > This is true, but you'll note this patch doesn't make any noise in the event
> > that a firmware isn't found until all the search paths are exhausted.  I didn't
> > consider this "unexpected".
> 
> Yes, it will cause noise, suppose the firmware is in the last search path, and
> we may always get the warning during the first three searches, and it
> is certainly
> annoying, isn't it?
> 
Please re-read the patch, then point out to me which printk the above action
will trigger, because its not happening in my testing. If you'll take a look at
fw_get_filesystem_firmware, you'll see that if the filp_open on a firmware file
fails, we continue the for loop through the list of available search paths.  No
error is generated in the case you describe above.

The exceptions to that rule are:

1) If no file is found in _any_ of the search paths, in which case
fw_get_filesystem_firmware will return -ENOENT, causing _request_firmware to
print "Direct firmware load failed with error -ENOENT.  Falling back to user
helper".

2) If a file is successfully opened by fw_get_filesystem_firmware, but something
goes wrong during the read in fw_read_file_contents, we print "firmware
attempted to load <file>, but failed with error <X>", followed by the printk
from (1) indicating that we are falling back to the user mode helper path.

Both of these execptions should be rare, and are something the administrator
will want to know about, so as not to confuse the real error with the mystery
-ENOENT you would get if you fell back to the user mode helepr and it wansn't
configured on in the running kernel.

> >
> >> > that occur during loading are masked if firmware exists in multiple locations,
> >> > and may be masked entirely in the event that we fall back to the user mode
> >>
> >> You still can figure out the request falls back to user mode loading since we
> >> have the "firmware: direct-loading firmware %s" log.
> >>
> > Yes, but you're looking at it backwards, that only prints out if the direct load
> > works.  If it doesn't, you get silence, which is bad.
> 
> OK, you can change to only log the failure.
> 
That is exactly what this patch does.

> >
> >> > helper code.  It would be nice to see some of the more unexpected errors get
> >>
> >> What are the unexpected errors?
> >>
> > If you get a short read in the direct load path for example, or if someone
> > mounts an nfs share over the firmware search path and you get an ESTALE.
> 
> That is easy to find, and no one should mount one fs on firmware path.
> 
Thats really rather the problem isn't it? this patch is an assertion that its
not that easy to find the root cause of a firmware load problem currently, even
if you haven't done something dumb, like mount a network FS on your firmware
path.  And I agree you shouldn't do such things, but that doesnt' mean that
people won't or have good reason to try (I can certainly see mounting the
firmware path on an NFS mount for embedded system development with limited
storage).  Regardless, when people do do something silly, we should tell them
so, not mask the problem behind a mystery -ENOENT error.

> > Alternatively, if the vmalloc fails during the direct load path, these would be
> > "unexpected" errors
> 
> This one might make sense since size of some firmwares may be several mega
> bytes, and vmalloc space is a bit limited on 32bit arch, so how about just log
> this failure in fw_read_file_contents()?
> 
It does exactly that, and a 
little more.  Why just catch the vmalloc error?  What if kernel_read fails for
some reason?  I see no reason to catch the vmalloc error specifcally, when we
can catch any error generated by direct read path (that doesn't include simple
file not found errors for any single entry in the search path).

> >
> >> > logged, so in the event that you expect the direct firmware loader to work (like
> >> > if CONFIG_FW_LOADER_USER_HELPER is enabled), and something goes wrong, you can
> >> > figure out what happened.
> >>
> >> Looks we didn't meet this case, do you have real examples?
> >>
> > Yeah, we had a vmalloc failure in the direct load path, and unknowingly had
> > forgot to configure CONFIG_FW_LOADER_USER_HELPER, so the module load failed with
> > an ENOENT, even though the firmware was clearly present on the filesystem.  This
> > patch helped us track that down.
> 
> Fair enough, looks it is helpful to add some log, :-)
> 
Thanks :)
Neil

