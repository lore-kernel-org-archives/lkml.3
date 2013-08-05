Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3HECjP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 22:39:15 -0400
Received: from dmz-mailsec-scanner-5.mit.edu ([18.7.68.34]:64345 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754200Ab3HECjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 22:39:14 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Aug 2013 22:39:13 EDT
X-AuditID: 12074422-b7ef78e000000935-0c-51ff0f2479f0
Message-ID: <51FF0F18.5020705@mit.edu>
Date: Sun, 04 Aug 2013 19:34:00 -0700
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: O_TMPFILE fs corruption (Re: Linux 3.11-rc4)
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
In-Reply-To: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsUixCmqrKvC/z/QYOIuOYvLu+awWTzqe8vu
	wORxYsZvFo/Pm+QCmKK4bFJSczLLUov07RK4Mnon72EvuMhV8b11J3sD41SOLkZODgkBE4nD
	mz6wQNhiEhfurWfrYuTiEBLYxyhx+P4lNpCEkMAGRokVi6ESZ5gkTnbtZQVJ8AqoSbxY/JAJ
	xGYRUJWY8e4jI4jNJqAi0bH0AVhcVCBMYtmLfmaIekGJkzOfgG0TETCS+PziCtgcZgEbiTPt
	38DiwgKmEucOf2KEWBwg0bXmADuIzSkQKHHzzzOoejOJrq1djBC2vMT2t3OYJzAKzkKyYhaS
	sllIyhYwMq9ilE3JrdLNTczMKU5N1i1OTszLSy3SNdXLzSzRS00p3cQICl92F6UdjD8PKh1i
	FOBgVOLhreD8HyjEmlhWXJl7iFGSg0lJlLeSBSjEl5SfUpmRWJwRX1Sak1p8iFGCg1lJhJe9
	/2+gEG9KYmVValE+TEqag0VJnPfZ07OBQgLpiSWp2ampBalFMFkZDg4lCd5kPqChgkWp6akV
	aZk5JQhpJg5OkOE8QMNNQWp4iwsSc4sz0yHypxgVpcR5jUASAiCJjNI8uF5YennFKA70ijAv
	H0gVDzA1wXW/AhrMBDTY5CfI1cUliQgpqQZG8Rn2/52M7zNvfPt98+JZFdPr+xvPJ0WIaiSo
	WAYqmHx21tlXq+8V/dmqYoku3wfVU2VvnVZm3ihqOlO9+apvh/rd8xwuf9t/HV1sfj24adKb
	vHvLBEJZyngr+Ko9Dng2aG3t9zhxfvnfTd0rZni2ZbgUXpta9XZmxPFtl6br83WcyZp6aX2e
	EktxRqKhFnNRcSIADGtq9QoDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2013 02:09 PM, Linus Torvalds wrote:
> It's that time of the week again..

I still get filesystem corruption with O_TMPFILE.  The program below, 
run as flinktest foo proc (or flinktest foo linkat if you're root) will 
produce a bogus inode.  On ext4, once the inode is gone from cache, the 
inode will be impossible to delete and will require a fsck to fix

A patch (not necessarily the appropriate fix) is here:

http://article.gmane.org/gmane.linux.kernel/1537088

--- cut here ---

#include <stdio.h>
#include <err.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

#define __O_TMPFILE 020000000
#define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
#define AT_EMPTY_PATH 0x1000

int main(int argc, char **argv)
{
   char buf[128];

   if (argc != 3)
     errx(1, "Usage: flinktest PATH linkat|proc");

   int fd = open(".", O_TMPFILE | O_RDWR, 0600);
   if (fd == -1)
     err(1, "O_TMPFILE");
   write(fd, "test", 4);

   if (!strcmp(argv[2], "linkat")) {
     if (linkat(fd, "", AT_FDCWD, argv[1], AT_EMPTY_PATH) != 0)
       err(1, "linkat");
   } else if (!strcmp(argv[2], "proc")) {
     sprintf(buf, "/proc/self/fd/%d", fd);
     if (linkat(AT_FDCWD, buf, AT_FDCWD, argv[1], AT_SYMLINK_FOLLOW) != 0)
       err(1, "linkat");
   } else {
     errx(1, "invalid mode");
   }
   return 0;
}

