Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab3HFXgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 19:36:15 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:50633 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab3HFXgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 19:36:14 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbK9oZJO+RJGC-7riO=Kz=UbRcAvQ-nDi=2GLyvEDpoc7g@mail.gmail.com>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
	<51FA3B02.7060004@linux.vnet.ibm.com>
	<3908561D78D1C84285E8C5FCA982C28F31CAA167@ORSMSX106.amr.corp.intel.com>
	<CA+8MBbLuhVDCb26ag3AH0vXrP4MXHLxS5aVn8pTi4=qL1NdR5w@mail.gmail.com>
	<CA+8MBbJ7x46FGC7dPSdNzf8z=fZz20w1kiNgnZr4QQB6SUELhg@mail.gmail.com>
	<51FFDC8B.7010909@linux.vnet.ibm.com>
	<CA+8MBb+1LpR+Cx=84WZT98U5eqZcm1KriUP75aCg+uSrXrb3Yw@mail.gmail.com>
	<51FFFFEB.3030907@linux.vnet.ibm.com>
	<CA+8MBbK9oZJO+RJGC-7riO=Kz=UbRcAvQ-nDi=2GLyvEDpoc7g@mail.gmail.com>
Date: Tue, 6 Aug 2013 16:36:13 -0700
Message-ID: <CA+8MBbKA+P4vs3utSKQ-LPMW3ybrWOp=f3FH6ahv1YtwnMm5KA@mail.gmail.com>
Subject: Re: [PATCH 00/11] Add compression support to pstore
From: Tony Luck <tony.luck@gmail.com>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "keescook@chromium.org" <keescook@chromium.org>
Content-Type: multipart/mixed; boundary=bcaec51d25b8f5768e04e34fe3f7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec51d25b8f5768e04e34fe3f7
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Aug 5, 2013 at 2:20 PM, Tony Luck <tony.luck@gmail.com> wrote:
> Still have problems booting if there are any compressed images in ERST
> to be inflated.

So I took another look at this part of the code ... and saw a couple of issues:

        while ((size = psi->read(&id, &type, &count, &time, &buf, &compressed,
                                psi)) > 0) {
                if (compressed && (type == PSTORE_TYPE_DMESG)) {
                        big_buf_sz = (psinfo->bufsize * 100) / 45;
                        big_buf = allocate_buf_for_decompression(big_buf_sz);

                        if (big_buf || stream.workspace)
>>> Did you mean "&&" here rather that "||"?
                                unzipped_len = pstore_decompress(buf, big_buf,
                                                        size, big_buf_sz);
>>> Need an "else" here to set unzipped_len to -1 (or set it to -1 down
>>> at the bottom of the loop ready for next time around.

                        if (unzipped_len > 0) {
                                buf = big_buf;
>>> This sets us up for problems.  First, you just overwrote the address
>>> of the buffer that psi->read allocated - so we have a memory leak. But
>>> worse than that we now double free the same buffer below when we
>>> kfree(buf) and then kfree(big_buf)
                                size = unzipped_len;
                                compressed = false;
                        } else {
                                pr_err("pstore: decompression failed;"
                                        "returned %d\n", unzipped_len);
                                compressed = true;
                        }
                }
                rc = pstore_mkfile(type, psi->name, id, count, buf,
                                  compressed, (size_t)size, time, psi);
                kfree(buf);
                kfree(stream.workspace);
                kfree(big_buf);
                buf = NULL;
                stream.workspace = NULL;
                big_buf = NULL;
                if (rc && (rc != -EEXIST || !quiet))
                        failed++;
        }


See attached patch that fixes these - but the code still looks like it
could be cleaned up a bit more.

-Tony

--bcaec51d25b8f5768e04e34fe3f7
Content-Type: application/octet-stream; name="pstore.patch"
Content-Disposition: attachment; filename="pstore.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hk1qwkcq0

ZGlmZiAtLWdpdCBhL2ZzL3BzdG9yZS9wbGF0Zm9ybS5jIGIvZnMvcHN0b3JlL3BsYXRmb3JtLmMK
aW5kZXggMzQ0NmM5OS4uZjg5MTc1OCAxMDA2NDQKLS0tIGEvZnMvcHN0b3JlL3BsYXRmb3JtLmMK
KysrIGIvZnMvcHN0b3JlL3BsYXRmb3JtLmMKQEAgLTQ3NCwxMiArNDc0LDE0IEBAIHZvaWQgcHN0
b3JlX2dldF9yZWNvcmRzKGludCBxdWlldCkKIAkJCWJpZ19idWZfc3ogPSAocHNpbmZvLT5idWZz
aXplICogMTAwKSAvIDQ1OwogCQkJYmlnX2J1ZiA9IGFsbG9jYXRlX2J1Zl9mb3JfZGVjb21wcmVz
c2lvbihiaWdfYnVmX3N6KTsKIAotCQkJaWYgKGJpZ19idWYgfHwgc3RyZWFtLndvcmtzcGFjZSkK
KwkJCWlmIChiaWdfYnVmICYmIHN0cmVhbS53b3Jrc3BhY2UpCiAJCQkJdW56aXBwZWRfbGVuID0g
cHN0b3JlX2RlY29tcHJlc3MoYnVmLCBiaWdfYnVmLAogCQkJCQkJCXNpemUsIGJpZ19idWZfc3op
OwogCiAJCQlpZiAodW56aXBwZWRfbGVuID4gMCkgeworCQkJCWtmcmVlKGJ1Zik7CiAJCQkJYnVm
ID0gYmlnX2J1ZjsKKwkJCQliaWdfYnVmID0gTlVMTDsKIAkJCQlzaXplID0gdW56aXBwZWRfbGVu
OwogCQkJCWNvbXByZXNzZWQgPSBmYWxzZTsKIAkJCX0gZWxzZSB7CkBAIC00OTYsNiArNDk4LDcg
QEAgdm9pZCBwc3RvcmVfZ2V0X3JlY29yZHMoaW50IHF1aWV0KQogCQlidWYgPSBOVUxMOwogCQlz
dHJlYW0ud29ya3NwYWNlID0gTlVMTDsKIAkJYmlnX2J1ZiA9IE5VTEw7CisJCXVuemlwcGVkX2xl
biA9IC0xOwogCQlpZiAocmMgJiYgKHJjICE9IC1FRVhJU1QgfHwgIXF1aWV0KSkKIAkJCWZhaWxl
ZCsrOwogCX0K
--bcaec51d25b8f5768e04e34fe3f7--
