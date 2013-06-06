Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab3FFSlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:41:32 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:50689 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3FFSlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:41:31 -0400
Date: Thu, 6 Jun 2013 20:41:29 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Strange intermittent EIO error when writing to stdout since
 v3.8.0
Message-ID: <20130606184129.GA6854@x4>
References: <20130606115417.GA520@x4>
 <12790.1370539861@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12790.1370539861@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.06.06 at 18:31 +0100, David Howells wrote:
> Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> 
> > OSError: [Errno 5] Input/output error
> > 
> > Basically 'emerge' just writes the build output to stdout in a loop:
> 
> I've just upgraded to kernel-3.9.4-200.fc18.x86_64 and I'm now regularly
> seeing something very similar from the tee run by "fedpkg local" to log its
> output when building a cross-compiler gcc RPM:
> 
> 	tee: standard output: Input/output error
> 	tee: write error
> 
> Slapping strace on tee after the "Input/output error" line has occurred shows
> that tee is still running and still pushing lines from its stdin to the output
> named on its command line, but has ceased writing to its stdout.

tee uses the same loop as portage, but keeps going in case of an EIO:

  /* In the array of NFILES + 1 descriptors, make
     the first one correspond to standard output.   */
  descriptors[0] = stdout;
  files[0] = _("standard output");
  setvbuf (stdout, NULL, _IONBF, 0);

  for (i = 1; i <= nfiles; i++)
    {
      descriptors[i] = (STREQ (files[i], "-")
                        ? stdout
                        : fopen (files[i], mode_string));
      if (descriptors[i] == NULL)
        {
          error (0, errno, "%s", files[i]);
          ok = false;
        }
      else
        setvbuf (descriptors[i], NULL, _IONBF, 0);
    }

  while (1)
    {
      bytes_read = read (0, buffer, sizeof buffer);
      if (bytes_read < 0 && errno == EINTR)
        continue;
      if (bytes_read <= 0)
        break;

      /* Write to all NFILES + 1 descriptors.
         Standard output is the first one.  */
      for (i = 0; i <= nfiles; i++)
        if (descriptors[i]
            && fwrite (buffer, bytes_read, 1, descriptors[i]) != 1)
          {
            error (0, errno, "%s", files[i]);
            descriptors[i] = NULL;
            ok = false;
          }
    }

-- 
Markus
