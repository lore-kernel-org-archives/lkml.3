Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab3HGB6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 21:58:35 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:37117 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3HGB6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 21:58:34 -0400
Message-ID: <5201A9BD.4090503@linux.vnet.ibm.com>
Date: Wed, 07 Aug 2013 07:28:21 +0530
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
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420> <51FA3B02.7060004@linux.vnet.ibm.com> <3908561D78D1C84285E8C5FCA982C28F31CAA167@ORSMSX106.amr.corp.intel.com> <CA+8MBbLuhVDCb26ag3AH0vXrP4MXHLxS5aVn8pTi4=qL1NdR5w@mail.gmail.com> <CA+8MBbJ7x46FGC7dPSdNzf8z=fZz20w1kiNgnZr4QQB6SUELhg@mail.gmail.com> <51FFDC8B.7010909@linux.vnet.ibm.com> <CA+8MBb+1LpR+Cx=84WZT98U5eqZcm1KriUP75aCg+uSrXrb3Yw@mail.gmail.com> <51FFFFEB.3030907@linux.vnet.ibm.com> <CA+8MBbK9oZJO+RJGC-7riO=Kz=UbRcAvQ-nDi=2GLyvEDpoc7g@mail.gmail.com> <CA+8MBbKA+P4vs3utSKQ-LPMW3ybrWOp=f3FH6ahv1YtwnMm5KA@mail.gmail.com>
In-Reply-To: <CA+8MBbKA+P4vs3utSKQ-LPMW3ybrWOp=f3FH6ahv1YtwnMm5KA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080701-2674-0000-0000-00000A224699
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 August 2013 05:06 AM, Tony Luck wrote:
> On Mon, Aug 5, 2013 at 2:20 PM, Tony Luck <tony.luck@gmail.com> wrote:
>> Still have problems booting if there are any compressed images in ERST
>> to be inflated.
> So I took another look at this part of the code ... and saw a couple of issues:
>
>          while ((size = psi->read(&id, &type, &count, &time, &buf, &compressed,
>                                  psi)) > 0) {
>                  if (compressed && (type == PSTORE_TYPE_DMESG)) {
>                          big_buf_sz = (psinfo->bufsize * 100) / 45;
>                          big_buf = allocate_buf_for_decompression(big_buf_sz);
>
>                          if (big_buf || stream.workspace)
>>>> Did you mean "&&" here rather that "||"?

Yes right, it should be &&.

>                                  unzipped_len = pstore_decompress(buf, big_buf,
>                                                          size, big_buf_sz);
>>>> Need an "else" here to set unzipped_len to -1 (or set it to -1 down
>>>> at the bottom of the loop ready for next time around.
>                          if (unzipped_len > 0) {
>                                  buf = big_buf;
>>>> This sets us up for problems.  First, you just overwrote the address
>>>> of the buffer that psi->read allocated - so we have a memory leak. But
>>>> worse than that we now double free the same buffer below when we
>>>> kfree(buf) and then kfree(big_buf)
>                                  size = unzipped_len;
>                                  compressed = false;
>                          } else {
>                                  pr_err("pstore: decompression failed;"
>                                          "returned %d\n", unzipped_len);
>                                  compressed = true;
>                          }
>                  }
>                  rc = pstore_mkfile(type, psi->name, id, count, buf,
>                                    compressed, (size_t)size, time, psi);
>                  kfree(buf);
>                  kfree(stream.workspace);
>                  kfree(big_buf);
>                  buf = NULL;
>                  stream.workspace = NULL;
>                  big_buf = NULL;
>                  if (rc && (rc != -EEXIST || !quiet))
>                          failed++;
>          }
>
>
> See attached patch that fixes these - but the code still looks like it
> could be cleaned up a bit more.

The patch looks right. I will clean it up. Does the issue still persist after this?

> -Tony

