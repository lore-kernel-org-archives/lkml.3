Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab3HERKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:10:44 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:53218 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab3HERKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:10:43 -0400
Message-ID: <51FFDC8B.7010909@linux.vnet.ibm.com>
Date: Mon, 05 Aug 2013 22:40:35 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "keescook@chromium.org" <keescook@chromium.org>
Subject: Re: [PATCH 00/11] Add compression support to pstore
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420> <51FA3B02.7060004@linux.vnet.ibm.com> <3908561D78D1C84285E8C5FCA982C28F31CAA167@ORSMSX106.amr.corp.intel.com> <CA+8MBbLuhVDCb26ag3AH0vXrP4MXHLxS5aVn8pTi4=qL1NdR5w@mail.gmail.com> <CA+8MBbJ7x46FGC7dPSdNzf8z=fZz20w1kiNgnZr4QQB6SUELhg@mail.gmail.com>
In-Reply-To: <CA+8MBbJ7x46FGC7dPSdNzf8z=fZz20w1kiNgnZr4QQB6SUELhg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080517-9574-0000-0000-0000090B8A38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

Thank you very much for testing my patches.

On Saturday 03 August 2013 03:42 AM, Tony Luck wrote:
> A quick experiment to use your patchset - but with compression
> disabled by tweaking this line in pstore_dump():
>
>      zipped_len = -1; //zip_data(dst, hsize + len);
>
> turned out well. This kernel dumps uncompressed dmesg blobs into pstore
> and gets them back out again.  So it seems likely that the problems are
> someplace in the compression/decompression code.

A quick look on my code suggests that problem could be in this part
of code.

In pstore_dump:

          if (zipped_len < 0) {
                         dst = psinfo->buf;
                         hsize = sprintf(dst, "%s#%d Part%d\n",
                                         why, oopscount, part);
                         size = psinfo->bufsize - hsize;
                         dst += hsize;
                         compressed = false;

                         if (!kmsg_dump_get_buffer(dumper, true, dst,
size, &len))
                                 break;
                 } else {
                         compressed = true;
      --->               len = zipped_len;
                 }

I am returning zipped_len as the length of the compressed data (which also
has hsize compressed). So returning hsize + len in pstore_write callback
will be wrong. It should just have been zipped_len. This might be adding
junk characters.

Can you please replace this hunk with:

                 if (zipped_len < 0) {
                         pr_err("Compression failed\n");
                         dst = psinfo->buf;
                         hsize = sprintf(dst, "%s#%d Part%d\n",
                                         why, oopscount, part);
                         size = psinfo->bufsize - hsize;
                         dst += hsize;
                         compressed = false;

                         if (!kmsg_dump_get_buffer(dumper, true, dst,
size, &len))
                                 break;
                         total_len = hsize + len;
                 } else {
                         compressed = true;
                         total_len = zipped_len;
                 }

                 ret = psinfo->write(PSTORE_TYPE_DMESG, reason, &id, part,
                                     oopscount, compressed, total_len, psinfo);
                 if (ret == 0 && reason == KMSG_DUMP_OOPS && pstore_is_mounted())
                         pstore_new_entry = 1;

                 total += total_len;
                 part++;

With the above hunk, atleast I dont see junk characters at the end in power.

I apologise, since I do not have the suitable machine to test this I am
not able to reproduce the scenarios you are stating. I need your help
in testing this.

- Aruna

> -Tony
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>

